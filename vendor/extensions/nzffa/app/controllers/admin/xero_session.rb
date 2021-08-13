class Admin::XeroSessionController < ApplicationController
  only_allow_access_to :index,
    :when => :admin,
    :denied_url => { :controller => 'pages', :action => 'index' },
    :denied_message => 'You must have administrative privileges to perform this action.'

  def index
    unless XeroAuth.still_active?
      flash[:notice] = 'The connection to the Xero API needs to be re-authorized.'
      @redirect_url = XeroAuth.authorize_url
    else
      flash[:notice] = 'There is an active connection with the Xero API. "All systems are go!"'
    end
  end

  def oauth2callback
    if params[:code]
      XeroAuth.get_token_from_auth_code(params[:code])
      redirect_to index
    end
  end

end
