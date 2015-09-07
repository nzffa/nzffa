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
      subscription.price_when_sold_without_research_contribution -
        (subscription.price_when_sold_without_research_contribution * 
         fraction_used(subscription.begins_on, 
                       subscription.expires_on))
    end
  end


  def self.upgrade_price(old_sub, new_sub)
    levy_for(new_sub) - credit_if_upgraded(old_sub)
  end

  def self.levy_for(subscription)
    CreateOrder.from_subscription(subscription).amount
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

end
