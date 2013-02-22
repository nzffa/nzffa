class SubscriptionsController < MarketplaceController
  radiant_layout "no_layout"
  before_filter :require_current_reader
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
  end

  def new
    if Subscription.active_subscription_for(current_reader)
      flash[:error] = 'You cannot create a new subscription if you currently have a subscription.'
      redirect_to subscriptions_path and return
    end
    @action_path = subscriptions_path
    @subscription = Subscription.new(params[:subscription])
    @subscription.reader = current_reader

    #yea.. crazy right.
    if Rails.env == 'production'
      if Date.today < Date.parse('2013-01-01')
        @subscription.begins_on = Date.parse('2013-01-01')
        @subscription.expires_on = Date.parse('2013-12-31')
      end
    end
  end

  def quote_new
    subscription = Subscription.new(params[:subscription])
    order = CreateOrder.from_subscription(subscription)

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
    if Subscription.active_subscription_for(current_reader)
      flash[:error] = 'You already have an active subscription'
      redirect_to subscriptions_path and return
    end
    @subscription = Subscription.new(params[:subscription])
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
end
