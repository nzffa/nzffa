class MembershipController < MarketplaceController
  include UpdateReaderNewsletterPreferences
  AFTER_SIGNUP_PATH = '/become-a-nzffa-member/youre-registered'
  before_filter :require_reader, :only => [:details, :update]
  radiant_layout { |c| Radiant::Config['reader.layout'] }

  def details
    @reader = current_reader
    @subscription = Subscription.active_subscription_for(@reader)
    @last_year_subscription = Subscription.last_year_subscription_for(@reader)
  end

  def dashboard
    # if they are an FFT member take them to
    if @reader.group_ids.include? NzffaSettings.fft_marketplace_group_id
      redirect_to FFT_MEMBERS_AREA_PATH
    else
      redirect_to REGISTER_PATH
    end
  end

  def register
    if params[:reader]
      # form has been submitted
      if !params[:reader][:email].blank?
        # Honeypot field has been filled in, abort and redirect back
        redirect_to REGISTER_PATH and return
      else
        params[:reader][:email] = params[:reader].delete(:pdnlb)
      end
      if !current_reader
        # new member
        @reader = Reader.new(params[:reader])

        if @reader.save
          update_newsletter_preference
          # MembershipMailer.deliver_registration_email(params[:reader])
          @reader.send_activation_message
          flash[:notice] = "Thanks for registering with the NZFFA. #{@newsletter_alert} #{@fft_alert}"
          redirect_to '/membership/details/'
        end
      elsif !current_reader.is_secretary
        redirect_to update_membership_path
      else
        @reader = Reader.new(params[:reader])
        @reader.clear_password = params[:reader][:password]

        if @reader.valid?
          @reader.activated_at = DateTime.now
          update_newsletter_preference
          @reader.save!
          flash[:notice] = "Registration of #{@reader.name} was succesful."
          # TODO: untie this from conference extension;
          redirect_to '/conference_subscriptions/invite/'
        else
          @reader.email_field = session[:email_field]
        end
      end
    else
      @reader = Reader.new
    end

    render :layout => false if request.xhr?
  end

  def update
    @reader = current_reader

    if params[:reader]
      # form has been submitted
      if !params[:reader][:email].blank?
        # Honeypot field has been filled in, abort and redirect back
        redirect_to REGISTER_PATH and return
      else
        params[:reader][:email] = params[:reader].delete(:pdnlb)
      end
      
      @reader.update_attributes(params[:reader])
      if @reader.save
        update_newsletter_preference
        redirect_to '/membership/details/'
      end
    end

    render :layout => false if request.xhr?
  end
end
