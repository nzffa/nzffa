class SubscriptionsController < SiteController
  #radiant_layout "ffm_specialty_timbers"
  def new
    @subscription = Subscription.new(params[:subscription])
    case @subscription[:membership_type]
    when 'full'
      render :branch_membership_form
    else
      render :new
    end
  end

  def quote
    subscription = Subscription.new(params[:subscription])
    render :text => "$#{subscription.yearly_fee}"
  end
end
