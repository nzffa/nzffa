class Admin::XeroSessionController < ApplicationController
  only_allow_access_to :index,
    :when => :admin,
    :denied_url => { :controller => 'pages', :action => 'index' },
    :denied_message => 'You must have administrative privileges to perform this action.'

  def index
    unless XeroAuth.still_active?
      # Try refresh_token
      XeroAuth.reconnect_from_refresh_token
      unless XeroAuth.still_active? # refresh token failed as well..
        flash[:notice] = 'The connection to the Xero API needs to be re-authorized.'
        @auth_url = XeroAuth.authorize_url
      end
    end
  end

  def oauth2callback
    if params[:code]
      XeroAuth.get_tokens_from_auth_code(params[:code])
      redirect_to admin_xero_session_status_path
    end
  end

end
