require 'spec_helper'

describe Order do

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
      }.should change{ order.order_lines.size }.by(1)
      order.order_lines.last.amount.should == -4.5
    end
  end

  describe 'calculate_amount' do
    context 'order_lines sum to positive amounts' do
      before :each do
        subject.add_charge(:kind => 'melons', :amount => 4.40)
        subject.add_charge(:kind => 'melons', :amount => 2.40)
      end
      it 'returns sum of order_lines amounts' do
        subject.calculate_amount.should == 6.8
      end
    end
    context 'order_lines sum to negative amounts' do
      before :each do
        subject.add_charge(:kind => 'melons', :amount => 4.40)
        subject.add_refund(:kind => 'rats', :amount => 8.40)
      end
      it 'returns 0' do
        subject.calculate_amount.should == 0
      end
    end
  end

  describe 'so you dont have to pay 0' do
    it 'sets order as paid if amount is 0 when saved' do
      order = Order.new
      sub = Subscription.new
      sub.save(false)
      order.subscription = sub
      order.add_refund(:kind => 'golden handshake', :amount => 1000000)
      order.save!
      order.paid?.should be_true
    end
  end

  describe 'marking as paid' do
    it 'throws exception unless payment_method is set' do
      lambda{ subject.paid! }.should raise_exception
    end

    describe 'with payment method' do
      before :each do
        subject.payment_method = 'Online'
      end

      it 'sets paid_on when paid!' do
        subject.paid!('Online')
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
          subject.paid!('Online')
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

end
