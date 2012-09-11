class SubscriptionsController < MarketplaceController
  #radiant_layout "ffm_specialty_timbers"
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
    levy = CalculatesSubscriptionLevy.levy_for(subscription)
    render :json => {:price => "#{number_to_currency(levy)}", 
                     :expires_on => subscription.expires_on.strftime('%e %B %Y').strip,
                     :begins_on => subscription.begins_on.strftime('%e %B %Y').strip}
  end

  def quote_upgrade
    current_sub = Subscription.active_subscription_for(current_reader)
    new_sub = Subscription.new(params[:subscription])

    normal_price = CalculatesSubscriptionLevy.levy_for(new_sub)
    upgrade_price = CalculatesSubscriptionLevy.
                      upgrade_price(current_sub, new_sub)

    credit = CalculatesSubscriptionLevy.
              credit_if_upgraded(current_sub)

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
      levy = CalculatesSubscriptionLevy.levy_for(@subscription)
      @subscription.save!
      @order = Order.create!(:amount => levy,
                            :subscription => @subscription,
                            :payment_method => 'Online',
                            :reader => current_reader)
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
