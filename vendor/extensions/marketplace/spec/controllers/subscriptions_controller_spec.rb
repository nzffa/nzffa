require 'spec_helper'

describe SubscriptionsController do
  let (:reader) { stub(:reader) }
  before :each do
    controller.stub(:current_reader).and_return(reader)
  end

  context 'new' do
    before do
      get :new
    end
    it 'initializes a new subscription' do
      assigns(:subscription).should be_present
    end
  end

  describe 'quote' do
    it 'returns a price given a subscription in params' do
      Subscription.stub(:new).and_return(stub(:subscription, 
                                              :quote_total_fee => 10,
                                              :quote_expires_on => Date.parse('2012-08-20')))
      get :quote, :subscription => {}
      JSON.parse(response.body).should == {"total_fee"=>"$10.00", "expires_on"=>"20 August 2012"}
    end
  end

  describe 'create' do
    # it initializes the subscriptoin
    # it checks if its valid
    # if valid then create an order around it
    # else call new

    describe 'if the subscription is valid' do
      let(:subscription){ stub(:subscription, 
                               :valid? => true,
                               :quote_total_fee => 10.0).as_null_object }
      let(:order){ stub(:order, :id => 1)}
      before :each do
        Subscription.stub(:new).and_return(subscription)
      end

      it 'creates an order against the reader and subscription' do
        subscription.should_receive(:reader=)
        subscription.should_receive(:save).and_return(true)
        Order.should_receive(:create, 
                             :amount => subscription.quote_total_fee,
                             :subscription => subscription,
                             :reader => reader).and_return(order)
        post :create
      end

      it 'redirects to the order#make_payment' do
        Order.stub(:create).and_return(order)
        post :create
        response.should redirect_to make_payment_order_path(order)
      end
    end

    describe 'if the subscription is invalid' do
      before :each do
        subscription = stub(:subscription, 
                            :valid? => false,
                            :[] => nil).as_null_object
        Subscription.stub(:new).and_return(subscription)
      end
      it 'does not create an order' do
        Order.should_not_receive(:create)
        post :create
      end
      it 'renders new' do
        controller.should_receive(:new)
        post :create
        response.should be_success
      end
    end

    #describe 'if subscription params are valid' do
      #before :each do
        #Subscription.stub(:new).and_return(subscription)
      #end

      #let(:valid_subscription_params) {
        #{:membership_type => 'fft_only',
         #:duration => 'full_year'}
      #}

      
      #it 'creates an order for the subscription' do
        #subscription.should_receive(:save).and_return(true)
        #expect {
          #post :create, :subscription => valid_subscription_params
        #}.to change(Order, :count).by(1)
      #end

      #it 'sets the order amount and paid?' do
        #post :create, :subscription => valid_subscription_params
        #assigns(:order).amount.should == subscription.quote_total_fee
        #assigns(:order).paid?.should == false
        #assigns(:order).subscription_id.should be_present
      #end

      #it 'redirects to the make_payment action for the order' do
        #post :create, :subscription => valid_subscription_params
        #assigns(:order)
        #response.should redirect_to make_payment_order_path(assigns(:order))
      #end

    #end
    #describe 'if subscription params are invalid' do
      #it 're renders the appropriate form'
    #end
  end
end
