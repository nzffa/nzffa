require 'lib/nzffa_settings'
require 'lib/calculates_subscription_levy'
require 'timecop'
describe CalculatesSubscriptionLevy do
  before :each do
    NzffaSettings.tree_grower_magazine_within_new_zealand = 40
    NzffaSettings.tree_grower_magazine_within_australia = 50
    NzffaSettings.tree_grower_magazine_everywhere_else = 60
  end

  context 'credit on current subscription' do
    it 'gives a full refund if subscription was bought today' do
      subscription = stub(:subscription, :price_when_sold => 10)
      subscription.
      UpgradesSubscription.credit_on_current_subscription(sub).should == 10

    end
  end

  it 'gives the credit on the current subscription' do
    sub = stub(:current_subscription,
               :begins_on => '2012-01-01',
               :expires_on => '2012-12-31')
    CalculatesSubscriptionLevy.credit_if_upgraded(sub)
    upgrader.credit_on_current_subscription.should == 10
  end

  describe 'levy for non year duration' do
    it 'gives 1.5 times levy for 1.5 times duration' do
      NzffaSettings.casual_member_fft_marketplace_levy = 50
      subscription = stub(:membership_type => 'casual',
                          :belong_to_fft? => true,
                          :receive_tree_grower_magazine? => false,
                          :begins_on => '2012-01-01',
                          :expires_on => '2013-06-01')
      CalculatesSubscriptionLevy.levy_for(subscription).should == 75
    end
  end

  describe 'length of year remaining to nearest quarter' do
    it 'gives expected values' do
      expectations = {'2012-01-01' => 1,
                      '2012-02-14' => 1,
                      '2012-02-15' => 0.75,
                      '2012-02-16' => 0.75,
                      '2012-05-14' => 0.75,
                      '2012-05-15' => 0.5,
                      '2012-08-14' => 0.5,
                      '2012-08-15' => 0.25,
                      '2012-11-14' => 0.25,
                      '2012-11-15' => 0,
                      '2012-12-21' => 0}
      expectations.each_pair do |date, value|
        Timecop.travel(date)
        CalculatesSubscriptionLevy.length_of_year_remaining.should == value

      end
      Timecop.return
    end
  end 

  describe 'subscription length' do
    it 'gives 1 for feb 14 to nov 16' do
      CalculatesSubscriptionLevy.subscription_length('2012-02-14', '2012-11-16').should == 1
    end
    it 'gives 1 for jan 1st to dec 31st' do
      begins_on = '2012-01-01'
      ends_on = '2012-12-31'
      CalculatesSubscriptionLevy.subscription_length(begins_on, ends_on).should == 1
    end

    it 'gives 0.25 for jan 1st to feb 15' do
      begins_on = '2012-01-01'
      ends_on = '2012-02-15'
      CalculatesSubscriptionLevy.subscription_length(begins_on, ends_on).should == 0.25
    end

    it 'gives 0.5 for jan 1st to may 1st' do
      begins_on = '2012-01-01'
      ends_on = '2012-05-01'
      CalculatesSubscriptionLevy.subscription_length(begins_on, ends_on).should == 0.25
    end

    it 'gives 1.25 for jan 1st 2012 to feb 15th 2013' do
      begins_on = '2012-01-01'
      ends_on = '2013-02-15'
      CalculatesSubscriptionLevy.subscription_length(begins_on, ends_on).should == 1.25
    end
  end

  describe 'for a full year' do
    let(:branches) {
      b1 = stub(:branch_1,  { :annual_levy => 5 })
      b2 = stub(:branch_2,  { :annual_levy => 10 })
      [b1, b2]
    }
    let(:subscription) {
      subscription_attributes = { 
        :begins_on => Date.parse('2012-01-01'),
        :expires_on => Date.parse('2012-12-31'),
        :belong_to_fft? => false,
        :branches => branches,
        :receive_tree_grower_magazine? => false }

        stub(:subscription, subscription_attributes).as_null_object
    }
    describe 'casual membership' do
      before :each do
        subscription.should_receive(:membership_type).and_return('casual')
      end

      it 'gives levy for fft marketplace membership' do
        NzffaSettings.casual_member_fft_marketplace_levy = 50
        subscription.should_receive(:belong_to_fft?).and_return(true)
        CalculatesSubscriptionLevy.yearly_levy_for(subscription).should == 50
      end

      describe 'nz tree grower magazine membership' do
        before :each do
          subscription.should_receive(:receive_tree_grower_magazine?).and_return(true)
        end

        it 'gives levy for nz subscribers' do
          subscription.should_receive(:tree_grower_delivery_location).and_return('new_zealand')
          CalculatesSubscriptionLevy.yearly_levy_for(subscription).should == 40
        end

        it 'gives levy for australian subscribers' do
          subscription.should_receive(:tree_grower_delivery_location).and_return('australia')
          CalculatesSubscriptionLevy.yearly_levy_for(subscription).should == 50
        end

        it 'gives levy for everyone else' do
          subscription.should_receive(:tree_grower_delivery_location).and_return('everywhere_else')
          CalculatesSubscriptionLevy.yearly_levy_for(subscription).should == 60
        end
      end

      it 'gives levy for both fft and tree grower magazine' do
        subscription.should_receive(:belong_to_fft?).and_return(true)
        subscription.should_receive(:receive_tree_grower_magazine?).and_return(true)
        subscription.should_receive(:tree_grower_delivery_location).and_return('new_zealand')
        CalculatesSubscriptionLevy.yearly_levy_for(subscription).should == 90
      end
    end

    describe 'full membership' do
      before :each do
        subscription.should_receive(:membership_type).and_return('full')
      end

      after :each do
        CalculatesSubscriptionLevy.yearly_levy_for(subscription)
      end

      it 'includes admin levy' do
        NzffaSettings.should_receive(:admin_levy).and_return 10
      end

      it 'includes forest area levy' do
        NzffaSettings.should_receive(:forest_size_levys).and_return({'0 - 10'  => 0, 
                                                                     '11 - 40' => 51, 
                                                                     '41+'     => 120})
      end

      describe 'charging for fft marketplace membership' do
        it 'should happen when belong_to_fft? is true' do
          subscription.should_receive(:belong_to_fft?).and_return(true)
          NzffaSettings.should_receive(:full_member_fft_marketplace_levy).and_return(10)
        end
        it 'should not happen when belong_to_fft? is false' do
          subscription.stub(:belong_to_fft?, false)
          NzffaSettings.should_not_receive(:full_member_fft_marketplace_levy)
        end
      end

      it 'includes a tree grower magazine levy' do
        NzffaSettings.should_receive(:full_member_tree_grower_magazine_levy).and_return(10)
      end

      it 'charges for each branch selected' do
        pending 'untested'
      end
    end
  end

end
