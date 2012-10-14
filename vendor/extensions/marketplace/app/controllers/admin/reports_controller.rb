class Admin::ReportsController < AdminController
  def index
  end

  def payments
    @orders = Order.find(:all, :order => 'id asc')
    fields = ['nzffa_member_id', 'subscription_id', 'order_id', 'amount', 'paid_on', 'payment_method']
    csv_string = FasterCSV.generate do |csv|
      csv << fields
      @orders.each {|order| csv << fields.map{|f| order.send(f) } }
    end
    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"nzffa_payments_#{DateTime.now.to_s}\"" 
    render :text => csv_string
  end

  def allocations
    @orders = Order.find(:all, :order => 'id asc')
    fields = ['nzffa_member_id', 'subscription_id', 'order_id', 'order_line_id', 'kind', 'particular', 'amount', 'paid_on', 'payment_method']
    csv_string = FasterCSV.generate do |csv|
      csv << fields
      @orders.each do |order| 
        order.order_lines.each do |line|
          csv << fields.map{|f| line.send(f) }
        end
      end
    end
    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"nzffa_allocations_#{DateTime.now.to_s}\"" 
    render :text => csv_string
  end
end
