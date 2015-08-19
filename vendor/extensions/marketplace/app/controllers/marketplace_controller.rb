class MarketplaceController < SiteController
  MY_ADVERTS_PATH = '/specialty-timber-market/marketplace/my-adverts/'
  MARKETPLACE_PATH = '/specialty-timber-market/marketplace'
  MEMBER_PATH = '/account'
  REGISTER_PATH = '/membership/register'
  JOIN_FFT_PATH = '/specialty-timber-market/join-fft'
  EDIT_COMPANY_LISTING_PATH = '/specialty-timber-market/marketplace/edit-company-listing'
  FFT_MEMBERS_AREA_PATH = '/specialty-timber-market/participate/membership'
  #NEWSLETTER_GROUP_ID = NzffaSettings.fft_newsletter_group_id
  #FFT_GROUP_ID = NzffaSettings.fft_marketplace_group_id
  ADMIN_GROUP_ID = 100

  protected
  def store_location
    session[:return_to] = request.url
  end

  def current_reader
    
    unless @current_reader
      if reader_session = ReaderSession.find
        @current_reader = reader_session.reader
      end
    end
    @current_reader
  end

  def require_current_reader
    unless current_reader
      store_location
      flash[:error] = 'Sorry, but you must be logged in to do this'
      redirect_to '/account/login'
    end
  end

  def require_no_current_reader
    if current_reader
      flash[:error] = 'Sorry, these actions are for creating new accounts'
      redirect_to '/account/'
    end
  end

  def require_fft_group
    unless current_reader.group_ids.include? NzffaSettings.fft_marketplace_group_id
      flash[:error] = 'Sorry, but you must belong to Farm Forestry Timbers Group'
      redirect_to root_path
    end
  end
end
