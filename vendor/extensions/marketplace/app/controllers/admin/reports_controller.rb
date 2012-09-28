class Admin::ReportsController < AdminController
  def index
  end

  def payments
    @orders = Order.find(:all, :order => 'id asc')
    fields = ['nzffa_member_id', 'subscription_id', 'order_id', 'amount', 'paid_on', 'payment_method']
    @rows = [fields]
    @orders.each {|order| @rows << fields.map{|f| order.send(f) } }
  end

  def allocations
    @orders = Order.find(:all, :order => 'id asc')
    fields = ['nzffa_member_id', 'subscription_id', 'order_id', 'order_line_id', 'kind', 'particular', 'amount', 'paid_on', 'payment_method']
    @rows = [fields]
    @orders.each do |order| 
      order.order_lines.each do |line|
        @rows << fields.map{|f| line.send(f) }
      end
    end
  end
end
