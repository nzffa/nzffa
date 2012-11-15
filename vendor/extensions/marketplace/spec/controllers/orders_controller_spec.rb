require 'spec_helper'
describe OrdersController do
  let(:reader) { stub(:reader) }
  before :each do 
    controller.stub(:current_reader).and_return(reader)
  end

  describe 'make_payment' do
    let(:order) { stub(:order, :id => 5,
                               :amount => 30.00,
                               :currency => 'NZD')}

    it 'forwards the user to the payment url' do
      Order.should_receive(:find) { order }
      PxPayParty.should_receive(:payment_url_for).
        with(:amount => order.amount,
             :merchant_reference => "Order:#{order.id}",
             :return_url => payment_finished_orders_url).
        and_return('http://paymentexpress.com')

      get :make_payment, :id => order.id
      response.should redirect_to 'http://paymentexpress.com'
    end

  end

  describe 'payment response' do
    describe 'success' do
      let(:subscription) {stub(:subscription).as_null_object}
      let(:order){stub(:order, :subscription => subscription).as_null_object}
      before :each do
        PxPayParty.stub(:payment_response).
          with('something').
          and_return({'MerchantReference' => 'Order:5',
                      'Success' => '1'})
        Order.stub(:find).and_return(order)

      end

      it 'renders success template' do
        get :payment_finished, :result => 'something'
        response.should render_template 'success'
      end

      it 'calls paid! on order' do
        order.should_receive(:paid!).and_return(true)
        get :payment_finished, :result => 'something'
      end

      it 'applys subscription groups to reader' do
        AppliesSubscriptionGroups.should_receive(:apply).with(subscription, reader)
        get :payment_finished, :result => 'something'
      end
    end

    it 'accepts fail responses' do
      PxPayParty.should_receive(:payment_response).
        with('something').
        and_return({'MerchantReference' => 'Order:5',
                    'Success' => '0'})
      order = stub(:order)
      Order.should_receive(:find).and_return(order)

      get :payment_finished, :result => 'something'
      response.should render_template 'failure'
    end
  end

end
