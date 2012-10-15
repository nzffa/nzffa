require 'spec_helper'
describe Admin::SubscriptionsController do
  before :each do
    @reader = Reader.create!(:forename => 'jim', 
                             :surname => 'david',
                             :email => 'jim@example.org',
                             :password => 'password',
                             :password_confirmation => 'password')

    @user = User.create!(:name => 'charles admin',
                         :email => 'cmoney@admin.com',
                         :login => 'cmoneyhoney',
                         :password => 'password',
                         :password_confirmation => 'password',
                         :admin => true)
    @existing_sub = Subscription.new(:membership_type => 'casual')
    @existing_sub.save(false)

    controller.stub(:current_user).and_return(@user)
  end

  context 'new subscription' do
    it 'requires a reader id' do
      get :new
      flash[:error].should == 'reader_id required'
      response.should redirect_to admin_readers_plus_path
    end

    context 'with a reader id' do
      context 'reader has an active subscription' do
        before :each do
          Subscription.stub(:active_subscription_for).and_return(@existing_sub)
        end

        it 'redirects to edit' do
          get :new, :reader_id => @reader.id
          response.should redirect_to edit_admin_subscription_path(@existing_sub)
        end
      end

      it 'shows new subscription form' do
        get :new, :reader_id => @reader.id
        response.should be_success
        response.should render_template 'subscriptions/new'
      end
    end
  end

  describe 'index' do
    it 'lists all subscriptions' do
      get :index
      assigns(:subscriptions).should be_present
      response.should be_success
    end
  end

  describe 'edit subscription' do
    it 'redirects if subscription is not found' do
      get :edit, :id => 5
      flash[:error] = 'subscription not found'
      response.should redirect_to admin_subscriptions_path
    end
    context 'with id' do
      it 'shows edit form' do
        Subscription.stub(:find).and_return(@existing_sub)
        get :edit, :id => 5
      end
    end
  end


  describe 'update subscription' do
    it 'upgrades and redirects to an upgrade order' do
      @order = Order.new
      @order.save(false)
      @new_sub = stub(:new_sub).as_null_object
      Subscription.stub(:find).and_return(@existing_sub)
      Subscription.stub(:new).and_return(@new_sub)
      Order.should_receive(:upgrade_subscription).with(@existing_sub, @new_sub).and_return(@order)
      put :update, :id => 5
      response.should redirect_to edit_admin_order_path
    end
  end

  describe 'cancel' do
    let(:subscription){stub(:subscription, :id => 5)}

    context 'with an active (paid) subscription' do
      before :each do
        Subscription.stub(:find).and_return(subscription)
        subscription.stub(:paid?).and_return(true)
      end

      it 'does not cancel the subscription' do
        subscription.should_not_receive :cancel!
        post :cancel, :id => subscription.id, :reader_id => @reader.id
      end
    end

    context 'with an unpaid subscription' do
      before :each do
        Subscription.stub(:find).and_return(subscription)
        subscription.stub(:paid?).and_return(false)
      end

      it 'cancels the subscription' do
        subscription.should_receive :cancel!
        post :cancel, :id => subscription.id, :reader_id => @reader.id
        response.should redirect_to admin_subscriptions_path
      end
    end
  end

  describe 'create' do
    let(:new_sub) { Subscription.new(:membership_type => 'casual',
                                     :tree_grower_delivery_location => 'new_zealand'
                        ).as_null_object }
    before :each do
      Subscription.stub(:new).and_return(new_sub)
    end

    context 'when reader already has a current subscription' do
      before :each do
        Subscription.stub(:current_subscription_for).and_return(true)
      end
      it 'redirects to subscriptions index' do
        post :create, :reader_id => @reader.id
        response.should redirect_to admin_subscriptions_path
      end
    end

  end
end
