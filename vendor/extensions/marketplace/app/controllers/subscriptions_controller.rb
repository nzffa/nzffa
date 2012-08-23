class SubscriptionsController < SiteController
  #radiant_layout "ffm_specialty_timbers"
  include ActionView::Helpers::NumberHelper

  def new
    @subscription = Subscription.new(params[:subscription])
    case @subscription[:membership_type]
    when 'nzffa'
      render :nzffa_form
    when 'fft_only'
      render :fft_only_form
    when 'tree_grower_only'
      render :tree_grower_only_form
    else
      render :new
    end
  end

  def quote
    subscription = Subscription.new(params[:subscription])
    render :json => {:total_fee => "#{number_to_currency(subscription.quote_total_fee)}", 
                     :expires_on => subscription.quote_expires_on.strftime('%e %B %Y')}
  end

  def create
    @subscription = Subscription.create(params[:subscription])
    @order = Order.create
    redirect_to make_payment_order_path(@order)
  end
end
