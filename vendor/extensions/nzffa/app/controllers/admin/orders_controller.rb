class Admin::OrdersController < Admin::ResourceController
  only_allow_access_to :index, :new, :edit, :create, :update, :remove, :destroy,
    :when => [:admin, :designer]

  def index
    if params[:reader_id]
      @subscriptions = Subscription.find(:all, :conditions => {:reader_id => params[:reader_id]})

      @orders = Order.find(:all, :conditions => {:subscription_id => @subscriptions.map(&:id)})
    else
      @orders = paginated? ? Order.paginate(pagination_parameters) : Order.all
    end
    
  end

  def new
    @subscription = Subscription.find params[:subscription_id]
    @order = Order.new(:subscription_id => params[:subscription_id])
    @order.amount = CalculatesSubscriptionLevy.levy_for(@subscription)
  end

  def edit
    @order = Order.find(params[:id])
    @order.paid_on ||= Date.today
    @order.order_lines.build
    @order.order_lines.build
    @order.order_lines.build
    @order.order_lines.build
    @order.order_lines.build
  end

  def show
    @order = Order.find params[:id]
  end

  def update
    @order = Order.find params[:id]
    if !@order.paid? && params[:order]["paid_on"] =~ /[\d]{4}-[\d]{1,2}-[\d]{2}/
      BackOfficeMailer.deliver_donation_receipt_to_member(@order)
    end
    @order.update_attributes(params[:order])
    if @order.paid?
      AppliesSubscriptionGroups.apply(@order.subscription, @order.reader)
    end
    flash[:notice] = "Order updated"
    redirect_to admin_order_path(@order)
  end

  def create
    @order = Order.new(params[:order])

    if @order.save
      if @order.paid?
        BackOfficeMailer.deliver_donation_receipt_to_member(@order)
        AppliesSubscriptionGroups.apply(@order.subscription, @order.reader)
      end
      flash[:notice] = 'Order created'
      redirect_to admin_order_path(@order)
    else
      render :new
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    #redirect_to admin_reader_orders_path(@order.reader), :notice => "Order #{@order.id} deleted"
    redirect_to :back, :notice => "Order #{@order.id} deleted"
  end
end
