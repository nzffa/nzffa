class Admin::SubscriptionsController < AdminController
  only_allow_access_to :index, :new, :edit, :create, :update, :remove, :destroy,
    :when => [:admin, :designer]

  before_filter :load_reader, :only => [:new, :create]

  def index
    @subscriptions = Subscription.paginate(:page => params[:page], :order => 'id desc')
  end

  def show
    @subscription = Subscription.find(params[:id])
  end

  def print
    @subscription = Subscription.find(params[:id])
    @order = CreateOrder.from_subscription(@subscription)
    @reader = @subscription.reader
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
      unless @subscription.paid?
        flash[:error] = 'You cannot upgrade a subscription if it has not beed paid'
        redirect_to admin_subscription_path(@subscription) and return
      end
      @action_path = admin_subscription_path(@subscription)
      @subscription.begins_on = Date.today
      @subscription.contribute_to_research_fund = false
      render 'subscriptions/modify'
    else
      flash[:error] = 'subscription not found'
      redirect_to admin_subscriptions_path
    end
  end


  def create
    if Subscription.active_subscription_for(@reader)
      flash[:error] = 'This reader already has an active subscription'
      redirect_to admin_subscriptions_path and return
    end
    @subscription = Subscription.new(params[:subscription])
    @subscription.reader = @reader
    
    if @subscription.save!
      @order = CreateOrder.from_subscription(@subscription)
      @order.save
      redirect_to edit_admin_order_path(@order)
    else
      render :new
    end
  end

  def update
    current_sub = Subscription.find(params[:id])
    unless current_sub.paid?
      flash[:error] = 'You cannot upgrade a subscription if it has not beed paid'
      redirect_to admin_subscription_path(@subscription) and return
    end
    new_sub = Subscription.new(params[:subscription])
    new_sub.reader = current_sub.reader
    if new_sub.valid?
      @order = CreateOrder.upgrade_subscription(:from => current_sub, :to => new_sub)
      redirect_to edit_admin_order_path(@order)
    else
      render :edit
    end
  end

  def cancel
    if @subscription = Subscription.find(params[:id])
      unless @subscription.paid?
        @subscription.cancel!
      else
        flash[:error] = 'You cannot cancel a paid subscription.. only modify it'
      end
    end

    redirect_to :back
  end

  #def destroy
    #current_sub = Subscription.find(params[:id])
    #current_sub.destroy
    #flash[:notice] = "deleted subscription #{params[id]}"
    #redirect_to admin_subscriptions_path
  #end


  private
  def load_reader
    unless params[:reader_id]
      flash[:error] = 'reader_id required'
      redirect_to admin_readers_plus_path and return
    end
    @reader = Reader.find(params[:reader_id])
  end
end
