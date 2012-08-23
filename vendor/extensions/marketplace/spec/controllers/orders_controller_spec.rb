require 'spec_helper'
describe OrdersController do
  describe 'make_payment' do
    let(:order) { stub(:order, :id => 5,
                               :amount => 30.00,
                               :currency => 'NZD')}

    it 'forwards the user to the payment url' do
      Order.should_receive(:find) { order }
      PxPayParty.should_receive(:payment_url_for).
        with(:amount => order.amount,
             :merchant_reference => "Order:#{order.id}").
        and_return('http://paymentexpress.com')

      get :make_payment, :id => order.id
      response.should redirect_to 'http://paymentexpress.com'
    end

    it 'accepts success responses' do
      PxPayParty.should_receive(:parse_result).with(:someresults)
      get :success
    end

    it 'accepts fail responses' do
      PxPayParty.should_receive(:parse_result).with(:someresults)
      get :failure
    end
  end

end
