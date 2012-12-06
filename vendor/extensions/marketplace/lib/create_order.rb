class CreateOrder
  def self.from_subscription(subscription)
    new(subscription).create_order
  end

  def self.upgrade_subscription(params)
    old_sub = params[:from]
    new_sub = params[:to]
    old_order = old_sub.order

    raise "old subscription is not paid yet. cannot upgrade" unless old_sub.paid?
    
    order = new(new_sub).create_order
    @subscription = new_sub
    
    fraction_used = CalculatesSubscriptionLevy.fraction_used(old_sub.begins_on, old_sub.expires_on)
    
    old_order.order_lines.each do |line|
      refund_amount = CalculatesSubscriptionLevy.refund_amount(line.amount, fraction_used)
      order.add_refund(:kind => line.kind, 
                       :particular => line.particular,
                       :amount => refund_amount)
    end

    old_sub.cancel!
    order.save!
    order

  end

  def initialize(subscription)
    @subscription = subscription
  end
  attr_accessor :subscription

  def create_order
    order = Order.new
    case subscription.membership_type
    when 'full'
      order.add_charge(:kind => 'admin_levy', 
                       :amount => admin_levy_amount)

      order.add_charge(:kind => 'forest_size_levy', 
                       :particular => subscription.ha_of_planted_trees,
                       :amount => forest_size_levy_amount)

      subscription.branches.each do |branch|
        order.add_charge(:kind => 'branch_levy',
                         :particular => branch.name,
                         :amount => branch_levy_amount(branch))
      end

      subscription.action_groups.each do |group|
        order.add_charge(:kind => 'action_group_levy',
                         :particular => group.name,
                         :amount => action_group_levy_amount(group))
      end

      order.add_charge(:kind => 'nz_tree_grower_magazine_levy',
                       :particular => 'full_membership',
                       :amount => full_member_tree_grower_magazine_levy_amount)

      if subscription.belong_to_fft?
        order.add_charge(:kind => 'fft_marketplace_levy',
                         :particular => 'full_membership',
                         :amount => full_member_fft_marketplace_levy_amount)
      end
    when 'casual'
      if subscription.receive_tree_grower_magazine?
        order.add_charge(:kind => 'casual_member_nz_tree_grower_magazine_levy',
                         :particular => subscription.tree_grower_delivery_location,
                         :amount => casual_nz_tree_grower_levy)
      end
      if subscription.belong_to_fft?
        order.add_charge(:kind => 'casual_member_fft_marketplace_levy',
                         :amount => casual_member_fft_marketplace_levy_amount)
      end
    else
      raise 'invalid membership type'
    end

    order.subscription = subscription
    order.amount = order.order_lines.map{|ol| ol.amount}.sum
    order
  end

  def casual_member_fft_marketplace_levy_amount
    subscription.length_in_years * 
      NzffaSettings.casual_member_fft_marketplace_levy
  end

  def full_member_fft_marketplace_levy_amount
    subscription.length_in_years * 
      NzffaSettings.full_member_fft_marketplace_levy
  end

  def full_member_tree_grower_magazine_levy_amount
    subscription.length_in_years * 
      NzffaSettings.full_member_tree_grower_magazine_levy
  end

  def action_group_levy_amount(group)
    subscription.length_in_years * group.annual_levy
  end

  def branch_levy_amount(branch)
    subscription.length_in_years * branch.annual_levy
  end
 
  def forest_size_levy_amount
    subscription.length_in_years * 
      NzffaSettings.forest_size_levys[subscription.ha_of_planted_trees]
  end 

  def admin_levy_amount
    @subscription.length_in_years * NzffaSettings.admin_levy
  end 

  def casual_nz_tree_grower_levy
    per_copy = case subscription.tree_grower_delivery_location
               when 'new_zealand'
                 NzffaSettings.tree_grower_magazine_within_new_zealand
               when 'australia'
                 NzffaSettings.tree_grower_magazine_within_australia
               when 'everywhere_else'
                 NzffaSettings.tree_grower_magazine_everywhere_else
               else
                 raise "unknown tree grower magazine deliver location: #{subscription.tree_grower_delivery_location}"
               end
    #raise "length: #{subscription.length_in_years.to_s} per_copy: #{per_copy} copies: #{subscription.nz_tree_grower_copies}"

    subscription.length_in_years * (per_copy.to_i * subscription.nz_tree_grower_copies.to_i)
  end

end
