# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  after_filter :discard_flash_if_xhr
  helper_method :current_user, :admin?, :authorized_for?
  
  private
  
  def current_user_session  
    return @current_user_session if defined?(@current_user_session)  
    @current_user_session = UserSession.find
  end  
  
  def current_user  
    @current_user = current_user_session && current_user_session.record  
  end
  
  
  def admin?
    current_user && current_user.email=="admin@nzffa.org.nz"
  end
  
  def authorized_for? object
    admin? || object.user == current_user
  end
  
  
  
  def discard_flash_if_xhr
    flash.discard if request.xhr?
  end
end
