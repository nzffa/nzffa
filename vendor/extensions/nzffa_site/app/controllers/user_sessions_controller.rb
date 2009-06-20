class UserSessionsController < ApplicationController
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    
    flash[:notice] = "Successfully logged in." if @user_session.save
    render :partial => "login_area", :layout => false
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    
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
