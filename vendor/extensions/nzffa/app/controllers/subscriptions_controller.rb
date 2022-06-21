class SubscriptionsController < ReaderActionController
  before_filter :require_reader, :except => [:renew, :print, :print_renewal]
  before_filter :try_to_log_in_from_token, :only => [:renew, :print, :print_renewal]
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
    @subscription.contribute_to_research_fund = false # errors when @subscription is nil (no active subscription for current reader)
    @subscription.begins_on = Date.today
  end

  def renew
    @action_path = subscriptions_path
    if old_sub = Subscription.active_subscription_for(current_reader)
      @subscription = old_sub.renew_for_year(Date.today.year + 1)
      @subscription.contribute_to_research_fund = false
      render :new
    elsif old_sub = Subscription.most_recent_subscription_for(current_reader)
      @subscription = old_sub.renew_for_year(Date.today.year)
      @subscription.contribute_to_research_fund = false
      render :new
    else
      flash[:error] = 'No previous subscription found'
      redirect_to(:action => :index) and return
    end
  end

  def print
    @subscription = Subscription.last_paid_subscription_for(current_reader)
    if @subscription.nil?
      flash[:error] = 'No active subscription found'
      redirect_to(:action => :index) and return
    else
      @order = @subscription.order
      render 'print', :layout => false
    end
  end

  def print_renewal
    if old_sub = Subscription.active_subscription_for(current_reader)
      @subscription = old_sub.renew_for_year(Date.today.year + 1)
    elsif old_sub = Subscription.most_recent_subscription_for(current_reader)
      @subscription = old_sub.renew_for_year(Date.today.year)
    else
      redirect_to :back
    end
    # @subscription = old_sub.renew_for_year(old_sub.expires_on.year + 1)
    @order = CreateOrder.from_subscription(@subscription)
    render 'print', :layout => false
  end

  def new
    if Subscription.active_subscription_for(current_reader)
      flash[:error] = 'You cannot create a new subscription if you currently have a subscription.'
      redirect_to subscriptions_path and return
    end
    @subscription = current_reader.threatening_duplicate_subscription || current_reader.subscriptions.new(params[:subscription])
    @action_path = subscriptions_path
  end

  def quote_new
    remove_empty_groups_from_params
    subscription = Subscription.new(params[:subscription])
    order = CreateOrder.from_subscription(subscription)

    render :json => {:price => "#{number_to_currency(order.amount)}",
                     :credit_card_fee => "#{number_to_currency(order.amount * 0.023)}",
                     :expires_on => subscription.expires_on.strftime('%e %B %Y').strip,
                     :begins_on => subscription.begins_on.strftime('%e %B %Y').strip}
  end

  def remove_empty_groups_from_params
    params['subscription']['branches'].reject!(&:blank?)
    params['subscription']['action_groups'].reject!(&:blank?)
  end

  def quote_upgrade
    remove_empty_groups_from_params
    reader = Reader.find_by_id(params[:subscription][:reader_id])# || current_reader
    current_sub = Subscription.active_subscription_for(reader)
    new_sub = Subscription.new(params[:subscription])

    normal_price = CreateOrder.from_subscription(new_sub).amount
    credit = CalculatesSubscriptionLevy.credit_if_upgraded(current_sub)

    upgrade_price = CalculatesSubscriptionLevy.upgrade_price(current_sub, new_sub)

    render :json => {:price => "#{number_to_currency(normal_price)}",
                     :credit_card_fee => "#{number_to_currency(normal_price * 0.023)}",
                     :credit => "#{number_to_currency(credit)}",
                     :upgrade_price => "#{number_to_currency(upgrade_price)}",
                     :expires_on => new_sub.expires_on.strftime('%e %B %Y').strip,
                     :begins_on => new_sub.begins_on.strftime('%e %B %Y').strip}
  end

  def create
    # In order to prevent the duplicate subscriptions and orders, and thereby
    # duplicate invoices in Xero, we are deviating from 'the rails way' here.
    # Rather than opening :edit and :update routes, add controller actions,
    # edit forms etc., we check for and re-use any existing 'abandoned'
    # subscription here, and update the invoice in Xero

    if @subscription = current_reader.threatening_duplicate_subscription
      # An 'abandoned' subscription exists so do not create a new one
      @subscription.group_subscriptions.clear
      @subscription.update_attributes(params[:subscription])

      if Subscription.active_anytime.find(:all, :conditions => ['reader_id = ? AND begins_on <= ? AND expires_on >= ?', current_reader.id, @subscription.begins_on, @subscription.expires_on]).size > 0
        flash[:error] = 'You already have an active subscription for this time'
        redirect_to subscriptions_path and return
      end

      if @subscription.valid?
        new_order = CreateOrder.from_subscription(@subscription)
        new_order.order_lines.build(kind: 'extra', particular: "Credit Card Surcharge", amount: number_with_precision(new_order.amount * 0.023, precision: 2))
        new_order.amount = new_order.calculate_amount
        @order = @subscription.order
        @order.order_lines = new_order.order_lines
        @order.update_attribute(:amount, new_order.amount) # all other attrs should not change
        @order.update_xero_invoice if @order.xero_id
        if params[:commit] == 'Pay by direct credit'
          redirect_to print_renewal_subscriptions_path
        else
          redirect_to make_payment_order_path(@order)
        end
      else
        render :new
      end
    else
      # Act as before (create a new subscription and order)
      @subscription = current_reader.subscriptions.new(params[:subscription])

      if Subscription.active_anytime.find(:all, :conditions => ['reader_id = ? AND begins_on <= ? AND expires_on >= ?', current_reader.id, @subscription.begins_on, @subscription.expires_on]).size > 0
        flash[:error] = 'You already have an active subscription for this time'
        redirect_to subscriptions_path and return
      end

      if @subscription.valid?
        @order = CreateOrder.from_subscription(@subscription)
        @order.order_lines.build(kind: 'extra', particular: "Credit Card Surcharge", amount: number_with_precision(@order.amount * 0.023, precision: 2))
        @order.amount = @order.calculate_amount # because of added CC order_line
        @order.save
        if params[:commit] == 'Pay by direct credit'
          redirect_to print_subscriptions_path
        else
          redirect_to make_payment_order_path(@order)
        end
      else
        render :new
      end
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
    if reader = Reader.find_by_id_and_perishable_token(params[:reader_id], params['token'])
      self.current_reader = reader
    else
      flash[:error] = 'Could not log in with that token. Please try logging in manually.'
    end
    require_reader
  end

end
