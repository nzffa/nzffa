class Admin::SubscriptionsController < AdminController
  only_allow_access_to :index, :new, :edit, :create, :update, :remove, :destroy,
    :when => [:admin, :designer]

  before_filter :load_reader, :only => [:new, :create]

  def batches_to_print
    read_batch_params
    @options = batch_params_hash

    @subscriptions = Subscription.expiring_before(@expiring_before)
    @subs_by_postcode = @subscriptions.reject{|s| s.reader.nil? }.group_by{|s| s.reader.postcode }
  end

  def print_batch
    read_batch_params

    @subscriptions = Subscription.expiring_before(@expiring_before)
    @subs_by_postcode = @subscriptions.reject{|s| s.reader.nil? }.group_by{|s| s.reader.postcode }

    @unsaved_orders = @subs_by_postcode[@postcode].map do |sub|
                        sub.begins_on = @expiring_before
                        sub.expires_on = @expiring_before.at_end_of_year
                        CreateOrder.from_subscription(sub)
                      end
    render :layout => false
  end



  def index
    @subscriptions = Subscription.paginate(:page => params[:page], :order => 'id desc')
  end

  def show
    @subscription = Subscription.find(params[:id])
  end

  def print
    @subscription = Subscription.find(params[:id])
    @order = @subscription.order
    render :layout => false
  end

  def print_form
    @subscription = Subscription.find(params[:id])
    @order = @subscription.order
    render :layout => false
  end

  def print_renewal
    old_sub = Subscription.find(params[:id])
    @subscription = old_sub.renew_for_year(Date.today.year+1)
    @order = CreateOrder.from_subscription(@subscription)
    render 'print', :layout => false
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

  def renew
    old_sub = Subscription.find(params[:id])
    @subscription = old_sub.renew_for_year(Date.today.year+1)
    @action_path = admin_reader_subscriptions_path(@subscription.reader)
    render 'subscriptions/new'
  end

  def create
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

  private

  def subscriptions_in_batches
    Subscription.expiring_before(@expiring_before).each_slice(@batch_size)
  end

  def load_reader
    unless params[:reader_id]
      flash[:error] = 'reader_id required'
      redirect_to admin_readers_plus_path and return
    end
    @reader = Reader.find(params[:reader_id])
  end

  def read_batch_params
    @postcode = params.fetch(:postcode) { nil }
    @expiring_before = Date.parse(params.fetch(:expiring_before) { "#{Date.today.year + 1}-01-01"})
  end

  def batch_params_hash
    {:expiring_before => @expiring_before,
     :postcode => @postcode}
  end
end
