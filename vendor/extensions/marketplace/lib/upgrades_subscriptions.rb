class UpgradesSubscriptions

  def self.unused_duration_in_years(expires_on)
    # how long between now and the end of the subscription
    # how many billable quarters are there from begin to end?
    1 - CalculatesSubscriptionLevy.subscription_length(Date.today, expires_on)
  end
end
