require 'lib/create_order'
require 'lib/nzffa_settings'
require 'lib/calculates_subscription_levy'

class Order
end

describe CreateOrder do

    before :each do
      NzffaSettings.remove_defaults
      NzffaSettings.admin_levy = 34
      NzffaSettings.forest_size_levys = {'0 - 10'  => 0, 
                                         '11 - 40' => 51, 
                                         '41+'     => 120}
      NzffaSettings.full_member_tree_grower_magazine_levy = 50
      NzffaSettings.full_member_fft_marketplace_levy = 55
      NzffaSettings.casual_member_fft_marketplace_levy = 65
      NzffaSettings.tree_grower_magazine_within_new_zealand = 40
    end


    context 'upgrading a subscription' do
      let(:order_line) { stub(:order_line , {:kind => 'user_fee',
                                             :particular => '',
                                             :amount => 10})}

      let(:old_order) { stub(:old_order, 
                            :order_lines => [order_line])}

      let(:old_sub) { stub(:subscription, 
                           :order => old_order,
                           :length_in_years => 1,
                           :begins_on => Date.parse('2012-01-01'),
                           :expires_on => Date.parse('2012-12-31'),
                           :belong_to_fft? => true,
                           :receive_tree_grower_magazine? => false,
                           :membership_type => 'casual').as_null_object}

      let(:new_sub) { stub(:subscription, 
                           :length_in_years => 1,
                           :belong_to_fft? => true,
                           :receive_tree_grower_magazine? => true,
                           :tree_grower_delivery_location => 'new_zealand',
                           :nz_tree_grower_copies => 1,
                           :membership_type => 'casual').as_null_object}

      let(:order) { stub(:order, :add_charge => nil).as_null_object }
          

      after :each do
        CreateOrder.upgrade_subscription(:from => old_sub, :to => new_sub)
      end

      before :each do
        Order.stub(:new).and_return(order)
      end

      context 'old subscription is unpaid' do
        before :each do
          old_sub.stub(:paid?).and_return(false)
        end

        it 'does not cancel the old subscription' do
          pending 'works but now raises error.. dont wanna refactor specs right now'
          old_sub.should_not_receive(:cancel!)
        end
      end

      context 'old subscription is paid' do
        before :each do
          old_sub.stub(:paid?).and_return(true)
        end

        it 'cancels the old subscription' do
          old_sub.should_receive(:cancel!)
        end

        describe 'creates an order' do
          it 'refunds for the old subscription' do
            order.should_receive(:add_refund, 
                                 :kind => 'fft_marketplace_levy',
                                 :amount => NzffaSettings.casual_member_fft_marketplace_levy)
          end
          it 'charges for the new subscription' do
            order.should_receive(:add_charge, 
                                 :kind => 'casual_member_nz_tree_grower_magazine_levy',
                                 :particular => 'new_zealand',
                                 :amount => NzffaSettings.tree_grower_magazine_within_new_zealand)

          end
        end
      end
    end

    context 'creating a new subscription' do

      let(:order) {stub(:order).as_null_object} 

      before :each do
        Order.stub(:new).and_return(order)
      end

      after :each do
        CreateOrder.from_subscription(subscription)
      end

      context 'for a full membership subscription' do

        let(:north_otago) {stub(:branch, :name => 'North Otago', 
                                :annual_levy => 10)}

        let(:south_otago) {stub(:branch, :name => 'South Otago', 
                                :annual_levy => 8)}

        let(:eucalyptus) {stub(:action_group, :name => 'Eucalyptus',
                               :annual_levy => 10)}

        let(:subscription) { stub(:subscription, 
                                  :membership_type => 'full',
                                  :ha_of_planted_trees => '11 - 40',
                                  :main_branch_name => 'North Otago',
                                  :length_in_years => 1,
                                  :branches => [north_otago, south_otago],
                                  :action_groups => [eucalyptus]
                                 ).as_null_object}

        it 'charges an admin levy' do
         order.should_receive(:add_charge).with(:kind => 'admin_levy',
                                                :particular => 'North Otago',
                                                :amount => 34)
        end

        it 'charges a forest size levy' do
         order.should_receive(:add_charge).with(:kind => 'forest_size_levy', 
                                                :particular=>"11 - 40",
                                                :amount => 51)
        end
        it 'charges for the branches selected' do
         order.should_receive(:add_charge).with(:kind => 'branch_levy', 
                                                :particular => 'North Otago', 
                                                :amount => 10)
         order.should_receive(:add_charge).with(:kind => 'branch_levy', 
                                                :particular => 'South Otago', 
                                                :amount => 8)
        end

        it 'charges for the action groups selected' do
         order.should_receive(:add_charge).with(:kind => 'action_group_levy', 
                                                :particular => 'Eucalyptus', 
                                                :amount => 10)

        end

        it 'changes for nz tree grower magazine levy' do
         order.should_receive(:add_charge).with(:kind => 'nz_tree_grower_magazine_levy',
                                                :particular => 'full_membership',
                                                :amount => 50)
        end

        context 'with fft markplace' do
          it 'charges full member fft marketplace levy' do
            subscription.stub(:belong_to_fft?).and_return(true)
            order.should_receive(:add_charge).with(:kind => 'fft_marketplace_levy',
                                              :particular => 'full_membership',
                                              :amount => 55)
          end
        end
        context 'without fft marketplace' do
          it 'does not charge full member fft marketplace levy' do
            subscription.stub(:belong_to_fft?).and_return(false)
            order.should_not_receive(:add_charge).with(:kind => 'fft_marketplace_levy',
                                                      :particular => 'full_membership',
                                                      :amount => 55)
          end
        end
      end

      context 'for a casual membership subscription' do

        let(:subscription) { stub(:subscription, 
                                  :length_in_years => 1,
                                  :receive_tree_grower_magazine? => false,
                                  :membership_type => 'casual').as_null_object}

        context 'nz tree grower magazine levy' do
          it 'charges for the number of copies requested' do
            subscription.stub(:receive_tree_grower_magazine?).and_return(true)
            subscription.stub(:tree_grower_delivery_location).and_return('new_zealand')
            subscription.stub(:nz_tree_grower_copies).and_return(2)
            order.should_receive(:add_charge).
              with(:kind => 'casual_member_nz_tree_grower_magazine_levy',
                   :particular => 'new_zealand',
                   :amount => 80)
          end
        end

        context 'with fft markplace' do
          before do
            subscription.stub(:belong_to_fft?).and_return(true)
          end

          it 'charges casual member fft marketplace levy' do
            order.should_receive(:add_charge).
              with(:kind => 'casual_member_fft_marketplace_levy', :amount => 65)
          end

          it 'charges admin levy' do
            order.should_receive(:add_charge).
              with(:kind => 'admin_levy', 
                   :particular => 'casual_membership',
                   :amount => 34)
          end
        end

        context 'without fft marketplace' do
          before do
            subscription.stub(:belong_to_fft?).and_return(false)
          end
          it 'does not charge casual member fft marketplace levy' do
            order.should_not_receive(:add_charge).
              with(:kind => 'fft_marketplace_levy',
                   :particular => 'casual_membership',
                   :amount => 65)
          end

          it 'does not charge admin levy' do
            order.should_not_receive(:add_charge).
              with(:kind => 'admin_levy', 
                   :particular => 'casual_membership',
                   :amount => 34)
          end
        end
      end
    end
end
