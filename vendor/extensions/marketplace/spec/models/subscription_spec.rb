require 'spec_helper'

describe Subscription do
  before do
    @subscription = Subscription.new
    @otago_branch = Branch.create(:name => 'Otago')
  end

  subject do
    @subscription
  end

  it 'sets associated branches by name' do
    subject.associated_branch_names = ['Otago']
    subject.branches.should == [@otago_branch]
  end

  it 'returns associated branch names' do
    subject.branches = [@otago_branch]
    subject.associated_branch_names.should == ['Otago']
  end

  it 'has main_branch' do
    subject.should respond_to(:main_branch)
  end

  it 'sets main branch by name' do
    subject.main_branch_name = 'Otago'
    subject.main_branch.should == @otago_branch
  end


  describe 'duration' do
    it 'can be the year in full' do
      subject.duration = 'year'
      subject.valid?
      subject.should have(0).errors_on(:duration)
    end

    it 'can be the remaining quarters of the year plus next year' do
      pending 'this is complicated'
      options = ['year', 'year_and_quarter', 'year_and_half', 'year_and_three_quarters']
      options.each do |option|
        subject.duration = 'year'
        subject.valid?
        subject.should have(0).errors_on(:duration)
      end
    end
  end

  context 'calculates the fees associated with' do
    before do
      Branch.create!(:name => 'North Otago', :annual_levy => 20)
      Branch.create!(:name => 'Waikato', :annual_levy => 15)
    end

    subject do
      Subscription.create(:membership_type => 'full',
                          :ha_of_planted_trees => '11 - 40',
                          :main_branch_name => 'North Otago',
                          :associated_branch_names => ['Waikato'],
                          :duration => 'full')
    end

    it 'admin levy' do
      subject.cost_of(:admin_levy).should == 34
    end

    it 'area of trees' do
      subject.cost_of(:ha_of_planted_trees).should == 51
    end

    it 'branches' do
      subject.cost_of(:branches).should == 35
    end

    it 'tree grower magazine' do
      subject.cost_of(:tree_grower_magazine).should == 50
    end

    it 'gives yearly fee' do
      subject.yearly_fee.should == 170
    end

  end
end
