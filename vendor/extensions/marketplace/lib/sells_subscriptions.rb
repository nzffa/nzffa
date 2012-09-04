class SellsSubscriptions
  def self.sell(subscription)
    subscription.valid?
    CalculatesSubscriptionLevy.levy_for(subscription)
  end
  
end
