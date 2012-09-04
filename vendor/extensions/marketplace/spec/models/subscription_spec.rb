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

  context 'calculates the expiry and begin dates' do
    context 'when duration is full' do
      before :each do
        @sub = Subscription.new(:duration => 'full_year')
      end
      it 'expires on is the end of the year' do
        @sub.quote_expires_on.should == Date.new(Date.today.year, 12, 31)
      end

      it 'begins on is the start of the year' do
        @sub.quote_begins_on.should == Date.new(Date.today.year, 01, 01)

      end
    end

    context 'when term is remainder of year plus next' do
      before :each do
       @sub = Subscription.new(:duration => 'remainder_of_year_plus_next_year')
      end
      it 'expires on is the end of next year' do
        end_of_next_year = Date.new(Date.today.year + 1, 12, 31)
        @sub.quote_expires_on.should == end_of_next_year
      end
      it 'begins on is today' do
        @sub.quote_begins_on.should == Date.today
      end
    end
  end

end
