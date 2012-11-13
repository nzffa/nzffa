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
    fields = ['nzffa_member_id', 'subscription_id', 'order_id', 
              'order_line_id', 'kind', 'particular', 'amount', 
              'paid_on', 'payment_method', 'subscription_begins_on', 'subscription_begins_on', 'subscription_expires_on']
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
    fields = %w[id nzffa_membership_id forename surname email phone mobile fax post_line1 post_line2 post_city post_province post_country postcode full_nzffa_member? main_branch_id associated_branch_ids_string action_group_names special_cases]
    csv_string = FasterCSV.generate do |csv|
      csv << fields
      @readers.each do |reader|
        csv << fields.map do |field| 
          if field.match(/_names$/)
            if names = reader.send(field)
              names.join('. ')
            else
              nil
            end
          else
            reader.send(field)
          end
        end
      end
    end
    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"nzffa_members_#{DateTime.now.to_s}\"" 
    render :text => csv_string
  end

  def deliveries
    @subscriptions = Subscription.active.find(:all, :conditions => {'receive_tree_grower_magazine' => true})
    fields = %w[id nzffa_membership_id name postal_address num_copies indigenous_group_member]
    csv_string = FasterCSV.generate do |csv|
      csv << fields
      @subscriptions.each do |sub|
        r = sub.reader
        next unless r
        csv << fields.map do |field|
          case field
          when 'num_copies' then sub.nz_tree_grower_copies
          when 'indigenous_group_member' then r.group_ids.include?(209).inspect
          else r.send(field)
          end
        end
      end
    end
    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"nzffa_tree_grower_magazine_deliveries_#{Date.today.to_s}\"" 
    render :text => csv_string
  end

  def expiries
    all_subscriptions = Subscription.find(:all, :conditions => ['expires_on < ? and expires_on > ?', Date.today, 3.months.ago])
    @subscriptions = all_subscriptions.select{|s| Subscription.active_subscription_for(s.reader).blank? }
  end
end
