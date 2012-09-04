require 'activesupport'
class CalculatesSubscriptionLevy
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
      levy += case subscription.tree_grower_delivery_location
              when 'new_zealand'
                NzffaSettings.tree_grower_magazine_within_new_zealand
              when 'australia'
                NzffaSettings.tree_grower_magazine_within_australia
              when 'everywhere_else'
                NzffaSettings.tree_grower_magazine_everywhere_else
              else
                raise 'unknown tree grower magazine deliver location'
              end
    end
    levy
  end

  def self.full_membership_levy(subscription)
    levy = 0
    levy += NzffaSettings.admin_levy
    levy += NzffaSettings.forest_size_levys[subscription.ha_of_planted_trees].to_i || 0

    if subscription.belong_to_fft?
      levy += NzffaSettings.full_member_fft_marketplace_levy
    end

    levy += NzffaSettings.full_member_tree_grower_magazine_levy

    levy += subscription.branches.map(&:annual_levy).sum
    levy
    
  end

end
