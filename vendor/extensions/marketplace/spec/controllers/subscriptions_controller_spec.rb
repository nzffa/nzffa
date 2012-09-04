require 'spec_helper'

describe SubscriptionsController do
  let (:reader) { 
    reader = Reader.create!(:email => 'test@example.org',
                   :forename => 'jim',
                   :surname => 'david',
                   :password => 'password',
                   :password_confirmation => 'password')

    reader.update_attribute(:activated_at, '2010-01-01')
    reader
  }
    
  before :each do
    controller.stub(:current_reader).and_return(reader)
  end

  describe 'index' do
    context 'with an active subscription' do
      it 'assigns the current_subscription' do
        @active_subscription = stub(:active_subscription)
        Subscription.stub(:active_subscription_for).and_return(@active_subscription)
        get :index
        assigns(:active_subscription).should == @active_subscription
      end
    end

    context 'without an active subscription' do
      it 'renders index' do
        Subscription.stub(:active_subscription_for).and_return(nil)
        get :index
        response.should render_template :index
        response.should be_success
      end
    end

  end


  context 'new' do
    before do
      get :new
    end
    it 'initializes a new subscription' do
      assigns(:subscription).should be_present
    end
  end

  describe 'quote_new' do
    it 'returns a price given a subscription in params' do
      CalculatesSubscriptionLevy.stub(:levy_for).and_return(10)
      Subscription.stub(:new).and_return(stub(:subscription, 
                                              :expires_on => Date.parse('2012-08-20'),
                                              :begins_on => Date.parse('2012-01-01')))
      post :quote_new, :subscription => {}
      JSON.parse(response.body).should == {"total_fee"=>"$10.00", 
                                           "expires_on"=>"20 August 2012",
                                           "begins_on" =>"1 January 2012"}
    end
  end

  describe 'quote_upgrade' do
    it 'returns the upgrade pricing information' do
      Subscription.should_receive(:active_subscription_for).with(reader)
      Subscription.should_receive(:new).and_return(stub(:new_sub, :expires_on => Date.parse('2012-12-31'),
                                                        :begins_on => Date.parse('2012-05-01')))
      upgrader = stub(:upgrader, :credit_on_current_subscription => 25,
                                 :upgrade_price => 25)
      UpgradesSubscription.should_receive(:new).and_return(upgrader)
      post :quote_upgrade, :subscription => {}
      JSON.parse(response.body).should == {"credit_on_current_subscription" => "$25.00",
                                           "upgrade_price" => "$25.00",
                                           "expires_on" => "31 December 2012",
                                           "begins_on" => "1 May 2012"}
    end
  end

  describe 'create' do
    # it initializes the subscriptoin
    # it checks if its valid
    # if valid then create an order around it
    # else call new

    describe 'if the subscription is valid' do
      let(:subscription){ Subscription.new }
      let(:order){ stub(:order, :id => 1)}
      before :each do
        subscription.stub(:valid?).and_return(true)
        CalculatesSubscriptionLevy.stub(:levy_for).and_return(10)
        Subscription.stub(:new).and_return(subscription)
      end

      it 'creates an order against the reader and subscription' do
        subscription.should_receive(:reader=)
        subscription.should_receive(:save!).and_return(true)
        Order.should_receive(:create!, 
                             :amount => 10,
                             :subscription => subscription,
                             :reader => reader).and_return(order)
        post :create
      end

      it 'redirects to the order#make_payment' do
        order = Order.new
        order.save(false)
        Order.stub(:create!).and_return(order)
        post :create
        response.should redirect_to make_payment_order_path(order)
      end
    end

    describe 'if the subscription is invalid' do
      let(:subscription){ Subscription.new }
      before :each do
        subscription.stub(:valid?).and_return(false)
        Subscription.stub(:new).and_return(subscription)
      end
      it 'does not create an order' do
        Order.should_not_receive(:create)
        post :create
      end
      it 'renders new' do
        post :create
        response.should render_template :new
      end
    end

  end
end
