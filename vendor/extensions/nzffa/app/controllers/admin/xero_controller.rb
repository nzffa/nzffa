class Admin::XeroController < ApplicationController
  only_allow_access_to :index,
    :when => :admin,
    :denied_url => { :controller => 'pages', :action => 'index' },
    :denied_message => 'You must have administrative privileges to perform this action.'

  def index
    unless XeroConnection.still_active?
      # Try refresh_token
      XeroConnection.reconnect_from_refresh_token
      unless XeroConnection.still_active? # refresh token failed as well..
        flash.now[:error] = 'There is no longer an active connection to the Xero API.'
        @auth_url = XeroConnection.authorize_url
      end
    end
  end

  def oauth2callback
    if params[:code]
      XeroConnection.get_tokens_from_auth_code(params[:code])
      redirect_to admin_xero_session_status_path
    end
  end

  def get_xero_id_for_reader
    # Should really be in Admin::ReadersController, but this 'll do..
    if XeroConnection.verify
      Reader.find(params[:id]).get_contact_id
      redirect_to :back
    else
      redirect_to admin_xero_session_status_path
    end
  end
end
