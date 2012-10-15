class MembershipController < MarketplaceController
  radiant_layout "ffm_specialty_timbers"
  AFTER_SIGNUP_PATH = '/become-a-member/youre-registered'

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

  def join_fft_button
    @reader = current_reader
    render :layout => false if request.xhr?
  end

  def join_fft
    if @reader = current_reader
      @reader.groups << Group.find(ADMIN_GROUP_ID) unless @reader.groups.include? Group.find(ADMIN_GROUP_ID)
      @reader.groups << Group.find(FFT_GROUP_ID) unless @reader.groups.include? Group.find(FFT_GROUP_ID)
      flash[:notice] = 'You have joined the FFT'
      redirect_to FFT_MEMBERS_AREA_PATH
    else
      flash[:notice] = 'You need to register or sign in before continuing'
      redirect_to MEMBER_PATH
    end
  end

  protected

  def update_newsletter_preference
    fft_newsletter_group = Group.find(NzffaSettings.fft_newsletter_group_id)
    nzffa_members_newsletter_group = Group.find(NzffaSettings.nzffa_members_newsletter_group_id)
    if params[:receive_fft_newsletter]
      unless @reader.groups.include? fft_newsletter_group
        @reader.groups << fft_newsletter_group
        @newsletter_alert = 'Subscribed to Farm Forestry Timbers Newsletter.'
      end
    else
      if @reader.groups.include? fft_newsletter_group
        @reader.groups.delete(newsletter_group)
        @newsletter_alert = 'Unsubscribed from Farm Forestry Timbers Newsletter.'
      end
    end

    if @reader.full_nzffa_member?
      if params[:receive_nzffa_members_newsletter]
        unless @reader.groups.include? nzffa_members_newsletter_group
          @reader.groups << nzffa_members_newsletter_group
          @newsletter_alert = 'Subscribed to NZFFA Members Newsletter.'
        end
      else
        if @reader.groups.include? nzffa_members_newsletter_group
          @reader.groups.delete(nzffa_members_newsletter_group)
          @newsletter_alert = 'Unsubscribed to NZFFA Members Newsletter.'
        end
      end
    end
  end

end
