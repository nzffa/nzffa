class SubscriptionsController < SiteController
  def new
    @subscription = Subscription.new(params[:subscription])
    case @subscription[:membership_type]
    when 'full'
      render :branch_membership_form
    else
      render :new
    end
  end
end
