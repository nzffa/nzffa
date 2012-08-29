require 'lib/applies_subscription_groups'
require 'app/models/nzffa_settings'
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
  let(:tree_grower_nz_group) { stub(:tree_grower_nz_group) }

  let(:subscription) { stub(:subscription).as_null_object }
  let(:reader) { stub(:reader, :groups => []) }

  before :each do
    Group.stub(:find).with(NzffaSettings.fft_group_id).and_return(fft_group)
    Group.stub(:find).with(NzffaSettings.tree_grower_nz_group_id).and_return(tree_grower_nz_group)
  end

  context 'an nzffa subscription' do

    before :each do
      subscription.stub(:membership_type).and_return('nzffa')
      subscription.stub(:main_branch).and_return(branch_1)
      subscription.stub(:branches).and_return([branch_1, branch_2, branch_3])
    end

    context 'with belong_to_fft' do
      it 'adds the fft group to the reader' do
        subscription.stub(:belong_to_fft).and_return(true)
        AppliesSubscriptionGroups.apply(subscription, reader)
        reader.groups.should include fft_group
      end
    end

    context 'without belong_to_fft' do
      it 'does not add the fft group to the reader' do
        subscription.stub(:belong_to_fft).and_return(false)
        AppliesSubscriptionGroups.apply(subscription, reader)
        reader.groups.should_not include fft_group
      end
    end

    context 'groups' do
      before :each do
        AppliesSubscriptionGroups.apply(subscription, reader)
      end

      it 'adds reader to tree grower group' do
        reader.groups.should include tree_grower_nz_group
      end

      it 'adds reader to the main branch group' do
        reader.groups.should include group_1
      end

      it 'adds reader to associated branch groups' do
        reader.groups.should include group_2, group_3
      end
    end
  end

  context 'a fft_only subscription' do
    before :each do
      subscription.stub(:membership_type).and_return('fft_only')
      AppliesSubscriptionGroups.apply(subscription, reader)
    end

    it 'adds reader to fft group' do
      reader.groups.should include fft_group
    end
  end

  context 'a tree grower subscription' do
    before :each do
      subscription.stub(:membership_type).and_return('tree_grower_only')
      AppliesSubscriptionGroups.apply(subscription, reader)
    end

    context 'nz region' do
      it 'adds reader to nz tree grower group' do
        reader.groups.should include tree_grower_nz_group
      end
    end

    context 'australia' do
      it 'adds reader to australia tree grower group' do
        pending 'do we need these groups?'
        reader.groups.should include tree_grower_australia_group
      end
    end

    context 'everywhere else' do
      it 'adds reader to elsewhere tree grower group' do
        pending 'do we need these groups?'
        reader.groups.should include tree_grower_world_group
      end
    end

  end
end
