class OrdersController < MarketplaceController
  before_filter :require_current_reader

  def make_payment
    @order = Order.find params[:id]
    redirect_to PxPayParty.payment_url_for(:amount => @order.amount,
                                           :merchant_reference => "Order:#{@order.id}",
                                           :return_url => payment_finished_orders_url)

  end

  def payment_finished
    success_or_failure
  end

  private

  def success_or_failure
    result = PxPayParty.payment_response(params[:result])
    model_class, id = result['MerchantReference'].split(':')
    @order = Module.const_get(model_class).find(id)
    @subscription = @order.subscription

    if result['Success'] == '1'
      @order.paid!('Online')
      AppliesSubscriptionGroups.apply(@order.subscription, current_reader)
      render :success
    else
      render :failure
    end
  end
end
