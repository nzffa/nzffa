require 'spec_helper'

describe Subscription do
  before do
    @subscription = Subscription.new
    @otago_branch = Branch.create(:name => 'Otago')
  end

  subject do
    @subscription
  end

  describe 'active_subscription_for' do
    let(:reader) { reader = Reader.new; reader.save(false); reader}
    before :each do 
      Timecop.travel('2012-06-01') 
    end

    after :each do
      Timecop.return 
    end

    context 'when there is an active subscription' do
      it 'returns the active subscription for the given reader' do
        subscription = Subscription.create(:membership_type => 'casual',
                            :belong_to_fft => true,
                            :receive_tree_grower_magazine => false,
                            :begins_on => Date.parse('2012-01-01'),
                            :expires_on => Date.parse('2012-12-31'),
                            :reader => reader)
        Subscription.active_subscription_for(reader).should == subscription
      end
    end
    context 'when there is no active subscription for the reader' do
      it 'returns nil' do
        Subscription.active_subscription_for(reader).should be_nil
      end
    end
  end

  describe 'price_when_sold' do
    context 'if it has been paid for' do
      it 'gives the price when the subscription was sold' do
        order = stub(:order, :paid? => true, :amount => 10)
        subscription = Subscription.new
        subscription.stub(:order).and_return(order)
        subscription.price_when_sold.should == 10
      end
    end

    context 'if it has not been paid for' do
      it 'returns nil' do
        subscription = Subscription.new
        subscription.price_when_sold.should == nil
      end
    end
  end

  describe 'cancel!' do
    it 'updates cancelled_on to today' do
      sub = Subscription.new
      sub.cancel!
      sub.cancelled_on.should == Date.today
    end
  end

  describe 'active?' do
    subject do
      Subscription.new(:begins_on => '2012-01-01',
                       :expires_on => '2012-01-01')
    end
    context 'todays date is betweem begins_on..ends_on' do
      before :each do
        Timecop.travel '2012-01-01'
      end
      context 'and it is not cancelled' do
        it {should be_active}
      end
      context 'but it is cancelled' do
        before :each do
          subject.cancelled_on = Date.parse('2012-01-01')
        end
        it {should_not be_active}
      end
    end

    context 'todays date is outside begins_on..ends_on' do
      before :each do
        Timecop.travel '2012-01-03'
      end
      it {should_not be_active}
    end
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
end
