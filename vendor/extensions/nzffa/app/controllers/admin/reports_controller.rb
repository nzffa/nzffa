class Admin::ReportsController < AdminController
  only_allow_access_to :index, :new, :edit, :create, :update, :remove, :destroy,
    :when => [:admin, :designer]

  def index
  end

  def past_members_no_subscription
    #fft_marketplace_group_id = 229
    #tree_grower_magazine_group_id = 80
    #full_membership_group_id = 232
    #fft_newsletter_group_id = 230
    #nzffa_members_newsletter_group_id = 211
    #Branch.all.map(&:group_id)
    #ActionGroup.all.map(&:group_id)
    #subscription_group_ids = [229, 80, 232, 230, 211]
    subscription_group_ids = [11, 12, 13, 15, 16, 17, 18, 19, 20, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39, 80, 201, 209, 211, 217, 221, 225, 229, 230, 232]
    csv_string = READER_CSV_LIB.generate do |csv|
      csv << %w[id nzffa_membership_id name email expired_on group_ids]
      @readers = Reader.all.select do |r| 
        if !r.active_subscription and r.group_ids.any?{|id| subscription_group_ids.include?(id) }
          mooched_ids = r.group_ids.select{|id| subscription_group_ids.include?(id) }

          if sub = Subscription.last_subscription_for(r)
            expired_on = sub.expires_on
          else
            expired_on = nil
          end
          csv << [r.id, r.nzffa_membership_id, r.name, r.email, expired_on, mooched_ids.join(' ')]
        end
      end
    end

    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"nzffa_past_members_no_subscription_#{DateTime.now.to_s}\".csv" 
    render :text => csv_string
  end

  def payments
    @orders = Order.find(:all, :conditions => 'paid_on IS NOT NULL', :order => 'id asc')
    fields = ['nzffa_member_id', 'subscription_id', 'order_id', 'amount', 'paid_on', 'payment_method']
    csv_string = READER_CSV_LIB.generate do |csv|
      csv << fields
      @orders.each {|order| csv << fields.map{|f| order.send(f) } }
    end
    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"nzffa_payments_#{DateTime.now.to_s}\".csv" 
    render :text => csv_string
  end

  def allocations
    @orders = Order.find(:all, :conditions => 'paid_on IS NOT NULL', :order => 'id asc')
    fields = ['nzffa_member_id', 'subscription_id', 'order_id', 
              'order_line_id', 'kind', 'particular', 'amount', 
              'paid_on', 'payment_method', 'subscription_begins_on', 'subscription_begins_on', 'subscription_expires_on']
    csv_string = READER_CSV_LIB.generate do |csv|
      csv << fields
      @orders.each do |order| 
        order.order_lines.each do |line|
          csv << fields.map{|f| line.send(f) }
        end
      end
    end
    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"nzffa_allocations_#{DateTime.now.to_s}\".csv" 
    render :text => csv_string
  end

  def members
    @readers = Reader.all
    fields = %w[id nzffa_membership_id forename surname email phone mobile fax post_line1 post_line2 
    post_city post_province post_country postcode full_nzffa_member? main_branch_group_id 
    associated_branch_group_ids_string action_group_group_ids_string special_cases identifiers
    bank_account_number tree_grower_group_ids]
    csv_string = READER_CSV_LIB.generate(:col_sep => "\t") do |csv|
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
    headers["Content-Disposition"] = "attachment; filename=\"nzffa_members_#{DateTime.now.to_s}\".csv" 
    render :text => csv_string
  end

  def deliveries
    @subscriptions = Subscription.active.find(:all, :conditions => {'receive_tree_grower_magazine' => true})
    fields = %w[id nzffa_membership_id forename surname postal_address post_line1 post_line2 post_city
    post_province post_country postcode num_copies indigenous_group_member]
    csv_string = READER_CSV_LIB.generate do |csv|
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
    headers["Content-Disposition"] = "attachment; filename=\"nzffa_tree_grower_magazine_deliveries_#{Date.today.to_s}\".csv" 
    render :text => csv_string
  end

  def expiries
    all_subscriptions = Subscription.find(:all, :conditions => ['expires_on < ? and expires_on > ?', Date.today, 3.months.ago])

    @subscriptions = all_subscriptions.select do |s|
      s.reader.present? and Subscription.active_subscription_for(s.reader).blank?
    end

    fields = %w[id nzffa_membership_id expired_on forename surname postal_address post_line1 post_line2 post_city
    post_province post_country postcode phone mobile num_copies indigenous_group_member]

    csv_string = READER_CSV_LIB.generate do |csv|
      csv << fields
      @subscriptions.each do |sub|
        r = sub.reader
        next unless r
        csv << fields.map do |field|
          case field
          when 'expired_on' then sub.expires_on.to_s
          when 'num_copies' then sub.nz_tree_grower_copies
          when 'indigenous_group_member' then r.group_ids.include?(209).inspect
          else r.send(field)
          end
        end
      end
    end
    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"subscription_expiries_3_months_to_#{Date.today.to_s}\".csv"
    render :text => csv_string
  end
end
