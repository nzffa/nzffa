require 'spec_helper'

describe Order do

  it 'requires an amount' do
    order = Order.new
    order.valid?
    order.should have.errors_on(:amount)
    order.should have(1).errors_on(:reader)
    order.should have(1).errors_on(:subscription)
  end

  describe 'adding a charge' do
    it 'creates an order_line when you add a charge' do
      order = Order.new
      lambda{
        order.add_charge(:kind => 'bananas', :particular => 'ripe', :amount => 4.5)
      }.should change{ order.order_lines.size }.by(1)
    end
  end

  describe 'adding a refund' do
    it 'creates an order line with negative charge' do
      order = Order.new
      lambda{
        order.add_refund(:kind => 'bananas', 
                         :particular => 'mouldy',
                         :amount => 4.5)
      }.should change{ order.order_lines }.by(1)
      order.order_lines.last.amount.should == -4.5
    end
  end
  describe 'marking as paid' do
    it 'throws exception unless payment_method is set' do
      lambda{ subject.paid! }.should raise_exception('Payment method required')
    end
    describe 'with payment method' do
      before :each do
        subject.payment_method = 'Online'
      end

      it 'sets paid_on when paid!' do
        subject.paid!
        subject.paid_on.should == Date.today
      end
      context 'an upgrade order' do
        let(:old_sub){Subscription.new}

        before :each do
          subject.kind = 'upgrade'
          subject.old_subscription = old_sub
        end

        it 'cancels the old subscription' do
          old_sub.should_receive(:cancel!)
          subject.paid!
        end
      end
    end
  end

  describe 'checking if paid' do
    it 'returns true on paid? if paid' do
      subject.paid_on = Date.today
      subject.paid?.should be_true
    end

    it 'returns false when not paid' do
      subject.paid_on = nil
      subject.paid?.should be_false
    end
  end

  describe 'upgrade subscription' do
    let(:old_sub){o = Subscription.new; o.save(false); o}
    let(:new_sub){o = Subscription.new; o.save(false); o}
    let(:reader){r = Reader.new; r.save(false); r}

    before :each do
      CalculatesSubscriptionLevy.stub(:upgrade_price).and_return(10)
      new_sub.stub(:reader).and_return(reader)
    end

    it 'creates an unpaid order' do
      order = Order.upgrade_subscription(old_sub, new_sub)
      order.paid?.should be_false
    end

    it 'sets amount as upgrade price' do
      CalculatesSubscriptionLevy.
        should_receive(:upgrade_price).
        with(old_sub, new_sub).
        and_return(10)
      order = Order.upgrade_subscription(old_sub, new_sub)

      order.amount.should == 10
    end

    it 'sets the reader' do
      Order.should_receive(:create).with hash_including(:reader => reader)
      Order.upgrade_subscription(old_sub, new_sub)
    end

    it 'sets the kind to upgrade' do
      Order.should_receive(:create).with hash_including(:kind => 'upgrade')
      Order.upgrade_subscription(old_sub, new_sub)
    end
  end
end
