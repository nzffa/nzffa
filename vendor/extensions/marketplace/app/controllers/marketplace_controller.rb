class MarketplaceController < SiteController
  MY_ADVERTS_PATH = '/specialty-timber-market/marketplace/my-adverts/'
  MARKETPLACE_PATH = '/specialty-timber-market/marketplace'
  radiant_layout "ffm_specialty_timbers"

  protected
  def require_current_reader
    unless current_reader
      flash[:error] = 'Sorry, but you must be logged in to do this'
      redirect_to root_path
    end
  end

  def require_no_current_reader
    if current_reader
      flash[:error] = 'Sorry, these actions are for creating new accounts'
      redirect_to '/account/'
    end
  end

  def require_fft_group
    unless current_reader.group_ids.include? 229
      flash[:error] = 'Sorry, but you must belong to Farm Forestry Timbers Group'
      redirect_to root_path
    end
  end
end
