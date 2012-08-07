class SubscriptionsController < SiteController
  def new
    @subscription = Subscription.new
  end
end
