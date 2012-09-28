class SubscriptionsController < MarketplaceController
  radiant_layout "no_layout"
  before_filter :require_current_reader
  include ActionView::Helpers::NumberHelper

  def index
    @subscription = Subscription.active_subscription_for(current_reader)
  end

  def modify
    @action_path = upgrade_subscriptions_path
    @subscription = Subscription.active_subscription_for(current_reader)
  end

  def new
    @action_path = subscriptions_path
    @subscription = Subscription.new(params[:subscription])
  end

  def quote_new
    subscription = Subscription.new(params[:subscription])
    order = CreateOrder.from_subscription(subscription)

    render :json => {:price => "#{number_to_currency(order.amount)}", 
                     :expires_on => subscription.expires_on.strftime('%e %B %Y').strip,
                     :begins_on => subscription.begins_on.strftime('%e %B %Y').strip}
  end

  def quote_upgrade
    current_sub = Subscription.active_subscription_for(current_reader)
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
    new_sub = Subscription.new(params[:subscription])
    new_sub.reader = current_reader
    if new_sub.valid?
      @order = Order.upgrade_subscription(current_sub, new_sub)
      redirect_to make_payment_order_path(@order)
    else
      render :modify
    end
  end
end
