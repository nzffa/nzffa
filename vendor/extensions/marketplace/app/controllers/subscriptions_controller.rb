class SubscriptionsController < MarketplaceController
  #radiant_layout "ffm_specialty_timbers"
  before_filter :require_current_reader
  include ActionView::Helpers::NumberHelper

  def new
    @subscription = Subscription.new(params[:subscription])
  end

  def quote
    subscription = Subscription.new(params[:subscription])
    render :json => {:total_fee => "#{number_to_currency(subscription.quote_total_fee)}", 
                     :expires_on => subscription.quote_expires_on.strftime('%e %B %Y')}
  end

  def create
    @subscription = Subscription.new(params[:subscription])
    @subscription.reader = current_reader
    if @subscription.valid?
      @subscription.save!
      @order = Order.create!(:amount => @subscription.quote_total_fee,
                            :subscription => @subscription,
                            :reader => current_reader)
      redirect_to make_payment_order_path(@order)
    else
      new
    end
  end
end
