require 'active_support'
class CalculatesSubscriptionLevy

  def self.fraction_used(begins_on, expires_on)
    begins_on = begins_on.to_date
    expires_on = expires_on.to_date
    today = Date.today

    if today < begins_on
      0
    elsif today > expires_on
      1
    else
      full_length = subscription_length(begins_on, expires_on)
      used_length = subscription_length(today, expires_on)
      if full_length == 0
        1
      else
        1 - (used_length / full_length)
      end
    end
  end

  def self.credit_if_upgraded(subscription)
    if subscription.price_when_sold == nil
      0
    else
      subscription.price_when_sold - 
        (subscription.price_when_sold * 
         fraction_used(subscription.begins_on, subscription.expires_on))
    end
  end

  def self.refund_amount(full_amount, fraction_used)
    if full_amount == nil
      0
    else
      full_amount - (full_amount * fraction_used)
    end
  end

  def self.upgrade_price(old_sub, new_sub)
    levy_for(new_sub) - credit_if_upgraded(old_sub)
  end

  def self.levy_for(subscription)
    subscription_length(subscription.begins_on, subscription.expires_on) * 
      yearly_levy_for(subscription)
  end

  def self.yearly_levy_for(subscription)
    case subscription.membership_type
    when 'casual' then casual_membership_levy(subscription)
    when 'full' then full_membership_levy(subscription)
    else
      0
    end
  end

  #the length is really focued around issues of tree grower magazine.. 
  # 215, 515 etc represent feb 15, may 15 (yearless)
  # which are publication dates of tree grower im told
  def self.subscription_length(begin_on, end_on)
    length = 0
    if begin_on and end_on
      d = begin_on.to_date
      end_on = end_on.to_date
      while d < end_on do
        d += 1.day
        day = d.strftime('%m%d').to_i
        length += 0.25 if [215, 515, 815, 1115].include?(day)
      end
    else
      length = 1
    end
    length
  end

  def self.length_of_year_remaining
    subscription_length(Date.today, Date.new(Date.today.year, 12, 31))
  end

  private
  def self.casual_membership_levy(subscription)
    levy = 0
    if subscription.belong_to_fft?
      levy += NzffaSettings.casual_member_fft_marketplace_levy
    end
    if subscription.receive_tree_grower_magazine?
      levy += casual_nz_tree_grower_levy(subscription)
    end
    levy
  end

  def self.casual_nz_tree_grower_levy(subscription)
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
    (per_copy.to_i * subscription.nz_tree_grower_copies.to_i)
  end

  def self.full_membership_levy(subscription)
    levy = 0
    levy += NzffaSettings.admin_levy
    levy += NzffaSettings.forest_size_levys[subscription.ha_of_planted_trees].to_i || 0

    if subscription.belong_to_fft?
      levy += NzffaSettings.full_member_fft_marketplace_levy
    end

    if subscription.contribute_to_research_fund?
      levy += subscription.research_fund_contribution_amount
    end

    levy += NzffaSettings.full_member_tree_grower_magazine_levy
    levy += subscription.branches.map(&:annual_levy).sum
    levy += subscription.action_groups.map(&:annual_levy).sum
    levy
    
  end

end
