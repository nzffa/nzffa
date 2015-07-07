require 'spec_helper'

describe Subscription do
  before do
    @subscription = Subscription.new
    @otago_branch = Branch.create(:name => 'Otago')
  end

  subject do
    @subscription
  end


  describe 'expiring' do
    before :each do
      @expiring_subscription = Subscription.new
      @expiring_subscription.save(false)
      @expiring_subscription.update_attribute(:expires_on, Date.today)
      Timecop.travel(Date.today) 
    end

    describe 'days to expiry' do
      it 'has 0 days to expire on expiry day' do
        @expiring_subscription.days_to_expire.should == 0
      end

      it 'gives 1 day to expire the day before expiry' do
        @expiring_subscription.update_attribute(:expires_on, Date.tomorrow)
        @expiring_subscription.days_to_expire.should == 1
      end

      it 'gives 30, 30 days before expires_on' do
        @expiring_subscription.update_attribute(:expires_on, 30.days.from_now)
        @expiring_subscription.days_to_expire.should == 30
      end

    end

    it 'returns subscriptions with expires_on on the given date' do
      Subscription.expiring_on(Date.today).should include @expiring_subscription
    end

    it 'does not return cancelled subscriptions' do
      @expiring_subscription.cancel!
      Subscription.expiring_on(Date.today).should_not include @expiring_subscription
    end
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
        order = CreateOrder.from_subscription(subscription)
        order.save!
        order.paid!('Online')

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

  describe 'paid?' do
    let(:paid_order){stub(:paid_order, :paid? => true)}
    let(:unpaid_order) {stub(:unpaid_order, :paid? => false)}

    subject do
      Subscription.new
    end

    it 'is true when the order is paid' do
      subject.stub(:order).and_return(paid_order)
      subject.paid?.should be_true
    end

    it 'is false if the order is nil' do
      subject.paid?.should be_false
    end

    it 'is false if the order is not paid' do
      subject.stub(:order).and_return(unpaid_order)
      subject.paid?.should be_false
    end
  end

  describe 'active?' do
    subject do
      Subscription.new(:begins_on => '2012-01-01',
                       :expires_on => '2012-01-01')
    end

    context 'when paid for' do
      let(:order){stub(:order, :paid? => true)}

      before :each do
        subject.stub(:order).and_return(order)
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


    context 'it has not been paid for' do
      before :each do
        Timecop.travel '2012-01-01'
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
