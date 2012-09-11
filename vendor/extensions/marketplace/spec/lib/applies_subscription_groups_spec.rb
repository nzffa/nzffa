require 'lib/applies_subscription_groups'
require 'lib/nzffa_settings'
require 'spec/mocks'

class Group
end

describe AppliesSubscriptionGroups do

  #branch_1 group is group_1
  let(:group_1)  { stub(:group) }
  let(:group_2)  { stub(:group) }
  let(:group_3)  { stub(:group) }
  let(:branch_1) { stub(:branch, :group => group_1) }
  let(:branch_2) { stub(:branch, :group => group_2) }
  let(:branch_3) { stub(:branch, :group => group_3) }
  let(:fft_group) { stub(:group) }
  let(:tree_grower_magazine_group) { stub(:tree_grower_magazine_group) }
  let(:full_membership_group) { stub(:full_membership_group) }

  let(:action_group_group) {stub(:action_group_group)}
  let(:action_group) {stub(:action_group, :group => action_group_group)}


  let(:subscription) { stub(:subscription).as_null_object }
  let(:reader) { stub(:reader, :groups => []) }

  before :each do
    Group.stub(:find).with(NzffaSettings.fft_marketplace_group_id).and_return(fft_group)
    Group.stub(:find).with(NzffaSettings.full_membership_group_id).and_return(full_membership_group)
    Group.stub(:find).with(NzffaSettings.tree_grower_magazine_group_id).and_return(tree_grower_magazine_group)
  end

  context 'an full membership subscription' do

    before :each do
      subscription.stub(:membership_type).and_return('full')
      subscription.stub(:main_branch).and_return(branch_1)
      subscription.stub(:branches).and_return([branch_1, branch_2, branch_3])
      subscription.stub(:action_groups).and_return([action_group])
    end

    it 'adds the full membership group' do
      AppliesSubscriptionGroups.apply(subscription, reader)
      reader.groups.should include full_membership_group
    end

    it 'adds the tree grower magazine group' do
      AppliesSubscriptionGroups.apply(subscription, reader)
      reader.groups.should include tree_grower_magazine_group
    end

    context 'with belong_to_fft' do
      it 'adds the fft group to the reader' do
        subscription.stub(:belong_to_fft?).and_return(true)
        AppliesSubscriptionGroups.apply(subscription, reader)
        reader.groups.should include fft_group
      end
    end

    context 'without belong_to_fft' do
      it 'does not add the fft group to the reader' do
        subscription.stub(:belong_to_fft?).and_return(false)
        AppliesSubscriptionGroups.apply(subscription, reader)
        reader.groups.should_not include fft_group
      end
    end

    context 'groups' do
      before :each do
        AppliesSubscriptionGroups.apply(subscription, reader)
      end

      it 'adds reader to tree grower group' do
        reader.groups.should include tree_grower_magazine_group
      end

      it 'adds reader to the main branch group' do
        reader.groups.should include group_1
      end

      it 'adds reader to associated branch groups' do
        reader.groups.should include group_2, group_3
      end

      context 'action groups' do
        it 'adds reader to action group groups' do
          reader.groups.should include action_group_group
        end
      end
    end
  end

  context 'a casual subscription' do
    before :each do
      subscription.stub(:membership_type).and_return('casual')
      subscription.stub(:belong_to_fft?).and_return(false)
      subscription.stub(:receive_tree_grower_magazine?).and_return(false)
    end

    it 'does not add full membership group' do
      AppliesSubscriptionGroups.apply(subscription, reader)
      reader.groups.should_not include full_membership_group
    end

    context 'with belong to fft' do
      it 'adds reader to fft group' do
        subscription.stub(:belong_to_fft?).and_return(true)
        AppliesSubscriptionGroups.apply(subscription, reader)
        reader.groups.should include fft_group
      end
    end

    context 'without belong to fft' do
      it 'does not add reader to fft group' do
        subscription.stub(:belong_to_fft?).and_return(false)
        AppliesSubscriptionGroups.apply(subscription, reader)
        reader.groups.should_not include fft_group
      end
    end

    context 'with receive_tree_grower_magazine' do
      it 'adds reader to tree grower magazine group' do
        subscription.stub(:receive_tree_grower_magazine?).and_return(true)
        AppliesSubscriptionGroups.apply(subscription, reader)
        reader.groups.should include tree_grower_magazine_group
      end
    end

    context 'without receive_tree_grower_magazine' do
      it 'does not add reader to tree grower magazine group' do
        subscription.stub(:receive_tree_grower_magazine?).and_return(false)
        AppliesSubscriptionGroups.apply(subscription, reader)
        reader.groups.should_not include tree_grower_magazine_group
      end
    end
  end
end
