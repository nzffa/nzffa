class PersonSessionsController < ApplicationController
  
  def new
    @person_session = PersonSession.new
  end
  
  def create
    @person_session = PersonSession.new(params[:person_session])
    
    flash[:notice] = "Successfully logged in." if @person_session.save
    render :partial => "login_area", :layout => false
  end
  
  def destroy
    @person_session = PersonSession.find
    @person_session.destroy
    
    flash[:notice] = "Successfully logged out."
    
    # This is necessary, as for some reason, doing a
    # "render :partial" does not destroy the session
    # bizzare! authlogic bug?
    redirect_to show_login_area_url
  end
  
  def show_login_area
    render :partial => "login_area", :layout => false
  end
  
end
