class MembershipController < MarketplaceController
  MEMBER_PATH = '/account'
  REGISTER_PATH = '/membership/register'
  JOIN_FFT_PATH = '/specialty-timber-market/join-fft'
  EDIT_COMPANY_LISTING_PATH = ' what is the edit company listing path'
  FFT_MEMBERS_AREA_PATH = '/specialty-timber-market/participate/membership'
  NEWSLETTER_GROUP_ID = 230
  FFT_GROUP_ID = 229
  ADMIN_GROUP_ID = 100

  def register
    if params[:reader]
      # form has been submitted
      if @reader = current_reader
        # just updating their details
        if @reader.update_attributes(params[:reader])
          update_newsletter_preference
          flash[:notice] = "Updated your details. #{@newsletter_alert}"
          redirect_to REGISTER_PATH
        end
      else
        # new member
        @reader = Reader.new(params[:reader])
        if @reader.save
          update_newsletter_preference
          flash[:notice] = "Thanks for registering with the NZFFA. #{@newsletter_alert}"
          redirect_to JOIN_FFT_PATH
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

  #timber market signup
  def signup
    if params[:advert]
      @company_listing = Advert.new(params[:advert])
      if @company_listing.save
        @reader = @company_listing.reader
      end
    else
      @company_listing = Advert.new(:is_company_listing => true)
      @company_listing.reader = Reader.new
    end
    render :layout => false if request.xhr?
  end

  protected
  def update_newsletter_preference
    newsletter_group = Group.find(NEWSLETTER_GROUP_ID)
    if params[:receive_newsletter]
      unless @reader.groups.include? newsletter_group
        @newsletter_alert = 'Subscribed to Newsletter.'
        @reader.groups << newsletter_group
      end
    else
      if @reader.groups.include? newsletter_group
        @newsletter_alert = 'Unsubscribed from Newsletter.'
        @reader.groups.delete(newsletter_group)
      end
    end
  end
end
