# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class NzffaController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  after_filter :discard_flash_if_xhr
  helper_method :current_person, :admin?, :authorized_for?
  
  private
  
  def current_person_session  
    return @current_person_session if defined?(@current_person_session)  
    @current_person_session = PersonSession.find
  end  
  
  def current_person  
    @current_person = current_person_session && current_person_session.record  
  end
  
  
  def admin?
    current_person && current_person.email=="admin@nzffa.org.nz"
  end
  
  def authorized_for? object
    admin? || object.person == current_person
  end
  
  
  
  def discard_flash_if_xhr
    flash.discard if request.xhr?
  end
end
