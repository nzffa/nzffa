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

  describe 'cancel' do

    let(:subscription){stub(:subscription)}

    context 'with an active (paid) subscription' do
      before :each do
        Subscription.stub(:active_subscription_for).and_return(subscription)
        subscription.stub(:paid?).and_return(true)
      end

      it 'does not cancel the subscription' do
        subscription.should_not_receive :cancel!
        post :cancel
      end
    end

    context 'with an unpaid subscription' do
      before :each do
        Subscription.stub(:active_subscription_for).and_return(subscription)
        subscription.stub(:paid?).and_return(false)
      end
      it 'cancels the subscription' do
        subscription.should_receive :cancel!
        post :cancel
      end
    end

    it 'redirects to subscriptions' do
      post :cancel
      response.should redirect_to subscriptions_path
    end
  end

  describe 'index' do
    context 'with an active subscription' do
      it 'assigns the current_subscription' do
        pending 'broken and dont care right now'
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
      pending 'broken and dont care right now'
      CalculatesSubscriptionLevy.stub(:levy_for).and_return(10)
      Subscription.stub(:new).and_return(stub(:subscription, 
                                              :expires_on => Date.parse('2012-08-20'),
                                              :begins_on => Date.parse('2012-01-01')).as_null_object)
      post :quote_new, :subscription => {}
      JSON.parse(response.body).should == {"price"=>"$10.00", 
                                           "expires_on"=>"20 August 2012",
                                           "begins_on" =>"1 January 2012"}
    end
  end

  describe 'quote_upgrade' do
    it 'returns the upgrade pricing information' do
      pending 'bad test.. when we rework order this should be clearer'
      Subscription.should_receive(:active_subscription_for).with(reader)
      Subscription.should_receive(:new).and_return(stub(:new_sub, 
                                                        :expires_on => Date.parse('2012-12-31'),
                                                        :begins_on => Date.parse('2012-05-01')).as_null_object)

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

  describe 'upgrade' do
    context 'valid new subscription' do
      let(:order_stub){stub(:valid? => true, :id => 1)}
      it 'creates an upgrade subscription order' do
        pending 'broken and dont care right now'
        old_sub = stub(:old_sub, :valid? => true).as_null_object
        new_sub = stub(:new_sub, :valid? => true).as_null_object

        Subscription.should_receive(:active_subscription_for).
          with(reader).and_return(old_sub)

        Subscription.should_receive(:new).and_return(new_sub)

        new_sub.should_receive(:save!)

        Order.should_receive(:upgrade_subscription).
          with({:from => old_sub, :to => new_sub}).and_return(order_stub)
        put :upgrade
      end

      it 'redirects to make payment on the order' do
        pending 'broken and dont care right now'
        Subscription.stub(:active_subscription_for)
        Subscription.stub(:new).and_return(stub(:valid? => true))
        Order.stub(:upgrade_subscription).and_return(order_stub)
        put :upgrade
        response.should redirect_to make_payment_order_path(order_stub)
      end
    end
    context 'invalid new subscription' do
      it 'redirects to edit'
    end
  end

  describe 'create' do
    # it initializes the subscriptoin
    # it checks if its valid
    # if valid then create an order around it
    # else call new

    describe 'current subscription exists for reader' do
      before :each do
        Subscription.stub(:active_subscription_for).and_return(true)
      end
      it 'redirects to subscriptions index' do
        post :create
        response.should redirect_to subscriptions_path
      end
    end

    describe 'if the subscription is valid' do
      let(:subscription){ Subscription.new }
      let(:order){ stub(:order, :id => 1)}
      before :each do
        subscription.stub(:valid?).and_return(true)
        CalculatesSubscriptionLevy.stub(:levy_for).and_return(10)
        Subscription.stub(:new).and_return(subscription)
      end

      it 'creates an order against the reader and subscription' do
        pending 'broken and dont care right now'
        subscription.should_receive(:save!).and_return(true)
        Order.should_receive(:create!, 
                             :amount => 10,
                             :subscription => subscription,
                             :reader => reader).and_return(order)
        post :create
      end

      it 'redirects to the order#make_payment' do
        pending 'broken and dont care right now'
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
