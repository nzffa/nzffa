require 'spec_helper'

describe Order do

  it 'requires and amount' do
    order = Order.new
    order.valid?
    order.should have(1).errors_on(:amount)
  end

end
