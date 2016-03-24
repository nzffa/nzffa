class SubscriptionsController < MarketplaceController
  radiant_layout "no_layout"
  before_filter :require_current_reader, :except => [:renew, :print, :print_renewal]
  include ActionView::Helpers::NumberHelper

  def index
    @subscription = Subscription.last_subscription_for(current_reader)
  end

  def cancel
    if @subscription = Subscription.active_subscription_for(current_reader)
      unless @subscription.paid?
        @subscription.cancel!
      else
        flash[:error] = 'You cannot cancel a paid subscription.. only modify it'
      end
    end

    redirect_to subscriptions_path
  end

  def modify
    @action_path = upgrade_subscriptions_path
    @subscription = Subscription.active_subscription_for(current_reader)
    @subscription.contribute_to_research_fund = false
    @subscription.begins_on = Date.today
  end

  def renew
    try_to_log_in_from_token
    @action_path = subscriptions_path
    if old_sub = Subscription.active_subscription_for(current_reader)
      @subscription = old_sub.renew_for_year(Date.today.year + 1)
    elsif old_sub = Subscription.most_recent_subscription_for(current_reader)
      @subscription = old_sub.renew_for_year(Date.today.year)
    else
      flash[:error] = 'No previous subscription found'
      @subscription = current_reader.subscriptions.build
      redirect_to :new and return
    end
    
    @subscription.contribute_to_research_fund = false
    render :new
  end
  
  def print
    try_to_log_in_from_token
    @subscription = Subscription.most_recent_subscription_for(current_reader)
    @order = @subscription.order
    render 'print', :layout => false
  end

  def print_renewal
    try_to_log_in_from_token
    if old_sub = Subscription.active_subscription_for(current_reader)
      @subscription = old_sub.renew_for_year(Date.today.year + 1)
    elsif old_sub = Subscription.most_recent_subscription_for(current_reader)
      @subscription = old_sub.renew_for_year(Date.today.year)
    else
      redirect_to :back
    end
    
    @subscription = old_sub.renew_for_year(old_sub.expires_on.year + 1)
    @order = CreateOrder.from_subscription(@subscription)
    render 'print', :layout => false
  end

  def new
    if Subscription.active_subscription_for(current_reader)
      flash[:error] = 'You cannot create a new subscription if you currently have a subscription.'
      redirect_to subscriptions_path and return
    end
    @action_path = subscriptions_path
    @subscription = Subscription.new(params[:subscription])
    @subscription.reader = current_reader
  end

  def quote_new
    subscription = Subscription.new(params[:subscription])
    order = CreateOrder.from_subscription(subscription)
    #puts params[:subscription].inspect
    #puts order.order_lines.map{|ol| [ol.kind, ol.amount.to_s]}.inspect

    render :json => {:price => "#{number_to_currency(order.amount)}", 
                     :expires_on => subscription.expires_on.strftime('%e %B %Y').strip,
                     :begins_on => subscription.begins_on.strftime('%e %B %Y').strip}
  end

  def quote_upgrade
    reader = Reader.find_by_id(params[:subscription][:reader_id])# || current_reader
    current_sub = Subscription.active_subscription_for(reader)
    new_sub = Subscription.new(params[:subscription])

    normal_price = CreateOrder.from_subscription(new_sub).amount

    credit = CalculatesSubscriptionLevy.credit_if_upgraded(current_sub)

    upgrade_price = CalculatesSubscriptionLevy.upgrade_price(current_sub, new_sub)

    render :json => {:price => "#{number_to_currency(normal_price)}",
                     :credit => "#{number_to_currency(credit)}",
                     :upgrade_price => "#{number_to_currency(upgrade_price)}",
                     :expires_on => new_sub.expires_on.strftime('%e %B %Y').strip,
                     :begins_on => new_sub.begins_on.strftime('%e %B %Y').strip}
  end

  def create
    @subscription = Subscription.new(params[:subscription])

    if Subscription.active_anytime.find(:all, :conditions => ['reader_id = ? AND begins_on <= ? AND expires_on >= ?', current_reader.id, @subscription.begins_on, @subscription.expires_on]).size > 0
      flash[:error] = 'You already have an active subscription for this time'
      redirect_to subscriptions_path and return
    end

    @subscription.reader = current_reader
    if @subscription.valid?
      @order = CreateOrder.from_subscription(@subscription)
      @order.save
      redirect_to make_payment_order_path(@order)
    else
      render :new
    end
  end

  def upgrade
    current_sub = Subscription.active_subscription_for(current_reader)
    unless current_sub.paid?
      flash[:error] = 'You cannot upgrade a subscription if it has not beed paid'
      redirect_to subscriptions_path and return
    end
    new_sub = Subscription.new(params[:subscription])
    new_sub.reader = current_reader
    if new_sub.valid?
      @order = CreateOrder.upgrade_subscription(:from => current_sub, :to => new_sub)
      redirect_to make_payment_order_path(@order)
    else
      render :modify
    end
  end

  def try_to_log_in_from_token
    unless (params[:token].nil? || params[:reader_id].nil?)
      self.current_reader = Reader.find_by_id_and_perishable_token(params[:reader_id], params['token'])
    else
      require_current_reader
    end
  end
end
