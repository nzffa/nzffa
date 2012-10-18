class Admin::ReportsController < AdminController
  def index
  end

  def payments
    @orders = Order.find(:all, :conditions => 'paid_on IS NOT NULL', :order => 'id asc')
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
    @orders = Order.find(:all, :conditions => 'paid_on IS NOT NULL', :order => 'id asc')
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

  def members
    @readers = Reader.all
    fields = %w[id nzffa_membership_id forename surname email phone mobile fax post_line1 post_line2 post_city post_province post_country postcode full_nzffa_member?]
    csv_string = FasterCSV.generate do |csv|
      csv << fields
      @readers.each do |reader|
        csv << fields.map{|field| reader.send(field) }
      end
    end
    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"nzffa_members_#{DateTime.now.to_s}\"" 
    render :text => csv_string
  end
end
