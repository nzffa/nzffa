class Admin::OrdersController < AdminController
  def new
    @subscription = Subscription.find params[:subscription_id]
    @order = Order.new(:subscription_id => params[:subscription_id])
    @order.amount = CalculatesSubscriptionLevy.levy_for(@subscription)
  end

  def edit
    @order = Order.find(params[:id])
  end

  def show
    @order = Order.find params[:id]
  end

  def update
    @order = Order.find params[:id]
    @order.update_attributes(params[:order])
    flash[:notice] = "Order updated"
    redirect_to admin_order_path(@order)
  end

  def create
    @order = Order.new(params[:order])
    @order.reader = @order.subscription.reader

    if @order.save
      if @order.paid?
        AppliesSubscriptionGroups.apply(@order.subscription, @order.reader)
      end
      flash[:notice] = 'Order created'
      redirect_to admin_order_path(@order)
    else
      render :new
    end
  end
end
