class Admin::SubscriptionsController < AdminController
  before_filter :load_reader, :only => [:new, :create]

  def index
    @subscriptions = Subscription.find(:all, :order => 'id desc')
  end

  def new
    if @existing_sub = Subscription.active_subscription_for(@reader)
      redirect_to edit_admin_subscription_path(@existing_sub)
    else
      @action_path = admin_reader_subscriptions_path(@reader)
      @subscription = Subscription.new(params[:subscription])
      @subscription.reader = @reader
      render 'subscriptions/new'
    end
  end

  def edit
    if @subscription = Subscription.find_by_id(params[:id])
      @action_path = admin_subscription_path(@subscription)
      render 'subscriptions/modify'
    else
      flash[:error] = 'subscription not found'
      redirect_to admin_subscriptions_path
    end
  end


  def create
    @subscription = Subscription.new(params[:subscription])
    @subscription.reader = @reader
    if @subscription.save
      redirect_to new_admin_order_path(:subscription_id => @subscription.id)
    else
      render :new
    end
  end

  def update
    current_sub = Subscription.find(params[:id])
    new_sub = Subscription.new(params[:subscription])
    new_sub.reader = current_reader
    if new_sub.valid?
      @order = Order.upgrade_subscription(current_sub, new_sub)
      redirect_to edit_admin_order_path(@order)
    else
      render :edit
    end
  end


  private
  def load_reader
    unless params[:reader_id]
      flash[:error] = 'reader_id required'
      redirect_to admin_readers_plus_path and return
    end
    @reader = Reader.find(params[:reader_id])
  end
end
