class OrdersController < ReaderActionController
  before_filter :require_reader, :except => :payment_finished

  def make_payment
    @order = Order.find params[:id]
    redirect_to PxPayParty.payment_url_for(:amount => @order.amount,
                                           :merchant_reference => "Order:#{@order.id}",
                                           :return_url => payment_finished_orders_url)

  end

  def show_payment_info
    @order = Order.find params[:id]
    @subscription = @order.subscription
    @reader = @subscription.reader
    if @reader != current_reader
      flash[:error] = "You are not allowed to view the payment details for this order"
      redirect_to :back and return
    end
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
      AppliesSubscriptionGroups.apply(@subscription, @subscription.reader)

      unless @subscription.reader.orders.select{|o| !o.paid_on.nil? }.size > 1
        BackOfficeMailer.deliver_new_member_paid_registration(@subscription.reader)
      else # has had a paid subscription before
        BackOfficeMailer.deliver_member_renewed_online(@subscription.reader)
      end
      render :success
    else
      render :failure
    end
  end
end
