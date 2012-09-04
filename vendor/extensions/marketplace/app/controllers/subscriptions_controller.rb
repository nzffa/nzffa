class SubscriptionsController < MarketplaceController
  #radiant_layout "ffm_specialty_timbers"
  before_filter :require_current_reader
  include ActionView::Helpers::NumberHelper

  def new
    @subscription = Subscription.new(params[:subscription])
  end

  def quote
    subscription = Subscription.new(params[:subscription])
    levy = CalculatesSubscriptionLevy.levy_for(subscription)
    render :json => {:total_fee => "#{number_to_currency(levy)}", 
                     :expires_on => subscription.expires_on.strftime('%e %B %Y').strip,
                     :begins_on => subscription.begins_on.strftime('%e %B %Y').strip}
  end

  def create
    @subscription = Subscription.new(params[:subscription])
    levy = CalculatesSubscriptionLevy.levy_for(@subscription)
    @subscription.reader = current_reader
    if @subscription.valid?
      @subscription.save!
      @order = Order.create!(:amount => levy,
                            :subscription => @subscription,
                            :reader => current_reader)
      redirect_to make_payment_order_path(@order)
    else
      render :new
    end
  end
end
