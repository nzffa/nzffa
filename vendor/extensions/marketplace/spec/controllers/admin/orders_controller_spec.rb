require 'spec_helper'
describe Admin::OrdersController do
  before :each do
    @user = create_admin_user
    controller.stub(:current_user).and_return(@user)
  end

  let(:order){ stub(:order).as_null_object }

  it 'shows a new order form' do
    Subscription.should_receive(:find).with("5")
    CalculatesSubscriptionLevy.should_receive(:levy_for).and_return(500)
    get :new, :subscription_id => 5
    response.should be_success
    response.should render_template 'new'
  end

  it 'edits an order' do
    @order = Order.new
    @order.save(false)
    get :edit, :id => @order.id
    response.should render_template 'edit'
    response.should be_success
  end

  it 'updates an order' do
    @existing_order = Order.new
    @existing_order.save(false)
    Order.should_receive(:find).and_return(@existing_order)
    @existing_order.should_receive(:update_attributes).and_return(true)
    put :update, :id => @existing_order.id
    response.should redirect_to admin_order_path(@existing_order)
  end

  describe 'show' do
    it 'shows an order' do
      Order.stub(:find).and_return(order)
      get :show, :id => 1
      response.should be_success
    end
  end

  describe 'create' do

    before :each do
      Order.stub(:new).and_return(order)
      AppliesSubscriptionGroups.should_receive(:apply)
    end

    it 'creates an order' do
      order.should_receive(:save).and_return(true)
      post :create
      flash[:notice].should == 'Order created'
    end

  end
  

end
