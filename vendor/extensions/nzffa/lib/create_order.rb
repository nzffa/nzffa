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
    order.old_subscription = old_sub
    @subscription = new_sub
    
    fraction_used = CalculatesSubscriptionLevy.fraction_used(old_sub.begins_on, old_sub.expires_on)
    
    old_order.refundable_order_lines.each do |line|
      next if line.amount == 0
      order.add_refund(:kind => line.kind, 
                       :particular => line.particular,
                       :amount => line.refund_amount(fraction_used))
    end


    #old_sub.cancel!
    order.save!
    order.remove_cancelling_order_lines!
    order

  end

  def initialize(subscription)
    @subscription = subscription
  end

  attr_accessor :subscription
  delegate :reader, :to => :subscription

  def create_order
    order = Order.new
    case subscription.membership_type
    when 'full'
      order.add_charge(:kind => 'admin_levy',
                       :particular => subscription.main_branch_name,
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

      if subscription.belongs_to_fft
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
      if subscription.belongs_to_fft
        order.add_charge(:kind => 'fft_marketplace_levy',
                         :particular => 'casual_membership',
                         :amount => casual_member_fft_marketplace_levy_amount)
        order.add_charge(:kind => 'admin_levy',
                         :particular => 'fft_marketplace',
                         :amount => admin_levy_amount)
      end
    else
      raise 'invalid membership type'
    end
    
    if subscription.contribute_to_research_fund?
      particular = if subscription.research_fund_contribution_is_donation?
                    'donation'
                  else
                    'payment'
                  end

      order.add_charge(:kind => 'research_fund_contribution',
                       :particular => particular,
                       :is_refundable => false,
                       :amount => subscription.research_fund_contribution_amount)
    end
    
    order.subscription = subscription
    order.amount = order.order_lines.map{|ol| ol.amount}.sum
    order
  end

  def casual_member_fft_marketplace_levy_amount
    subscription.length_in_years *
      NzffaSettings.casual_member_fft_marketplace_levy.to_i
  end

  def full_member_fft_marketplace_levy_amount
    subscription.length_in_years *
      NzffaSettings.full_member_fft_marketplace_levy.to_i
  end

  def full_member_tree_grower_magazine_levy_amount
    if reader.is_life_member? or
       reader.is_branch_life_member?
      0
    else
      subscription.length_in_years *
        NzffaSettings.full_member_tree_grower_magazine_levy.to_i
    end
  end

  def action_group_levy_amount(group)
    subscription.length_in_years * group.annual_levy.to_i
  end

  def branch_levy_amount(branch)
    if (subscription.main_branch == branch) and
      (reader.is_branch_life_member? or
       reader.is_paid_branch_life_member? or
       reader.is_life_member?)
      0
    else
      subscription.length_in_years * branch.annual_levy.to_i
    end
  end
 
  def forest_size_levy_amount
    if reader.is_branch_life_member? or reader.is_life_member?
      0
    else
      subscription.length_in_years *
        NzffaSettings.forest_size_levys[subscription.ha_of_planted_trees].to_i
    end
  end

  def admin_levy_amount
    if reader.is_branch_life_member? or reader.is_life_member?
      0
    else
      @subscription.length_in_years * NzffaSettings.admin_levy.to_i
    end
  end

  def casual_nz_tree_grower_levy
    per_copy = case subscription.tree_grower_delivery_location
               when 'new_zealand'
                 Group.tg_magazine_nz_group.annual_levy.to_i
               when 'australia'
                 Group.tgm_australia_group.annual_levy.to_i
               when 'everywhere_else'
                 Group.tgm_everywhere_else_group.annual_levy.to_i
               else
                 raise "unknown tree grower magazine deliver location: #{subscription.tree_grower_delivery_location}"
               end

    if reader.is_complimentary_tree_grower?
      0
    else
      subscription.length_in_years * (per_copy.to_i * subscription.nz_tree_grower_copies.to_i)
    end
  end
end
