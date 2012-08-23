class OrdersController < SiteController
  def make_payment
    @order = Order.find params[:id]
    redirect_to PxPayParty.payment_url_for(:amount => @order.amount,
                                           :merchant_reference => "Order:#{@order.id}")
  end
end
