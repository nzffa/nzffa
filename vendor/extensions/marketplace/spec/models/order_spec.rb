require 'spec_helper'

describe Order do

  it 'requires an amount' do
    order = Order.new
    order.valid?
    order.should have(1).errors_on(:amount)
    order.should have(1).errors_on(:reader)
    order.should have(1).errors_on(:subscription)
  end

  describe 'marking as paid' do
    it 'sets paid_on when paid!' do
      subject.paid!
      subject.paid_on.should == Date.today
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
