class MembershipController < MarketplaceController
  include UpdateReaderNewsletterPreferences
  radiant_layout "no_layout"
  AFTER_SIGNUP_PATH = '/become-a-member/youre-registered'
  before_filter :require_current_reader, :only => :details

  def details
    @reader = current_reader
    @subscription = Subscription.active_subscription_for(@reader)
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
      if @reader = current_reader
        # just updating their details
        if @reader.update_attributes(params[:reader])
          update_newsletter_preference
          flash[:notice] = "Updated your details. #{@newsletter_alert} #{@fft_alert}"
          redirect_to MEMBER_PATH
        end
      else
        # new member
        @reader = Reader.new(params[:reader])
        if @reader.save
          @reader.update_attribute(:activated_at, DateTime.now)
          update_newsletter_preference
          MembershipMailer.deliver_registration_email(params[:reader])
          flash[:notice] = "Thanks for registering with the NZFFA. #{@newsletter_alert} #{@fft_alert}"
          redirect_to AFTER_SIGNUP_PATH
        end
      end
    else
      @reader = current_reader || Reader.new
    end

    render :layout => false if request.xhr?
  end

  # dean wants this left in the code for a bit
  #
  def join_fft_button
    @reader = current_reader
    render :layout => false if request.xhr?
  end

  #def join_fft
    #if @reader = current_reader
      #@reader.groups << Group.find(ADMIN_GROUP_ID) unless @reader.groups.include? Group.find(ADMIN_GROUP_ID)
      #@reader.groups << Group.find(FFT_GROUP_ID) unless @reader.groups.include? Group.find(FFT_GROUP_ID)
      #flash[:notice] = 'You have joined the FFT'
      #redirect_to FFT_MEMBERS_AREA_PATH
    #else
      #flash[:notice] = 'You need to register or sign in before continuing'
      #redirect_to MEMBER_PATH
    #end
  #end
end
