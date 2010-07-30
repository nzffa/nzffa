require_dependency 'application_controller'

class NzffaSiteExtension < Radiant::Extension
  version "1.0"
  description "Home for all NZFFA specific alterations, both frontend and admin side. Has adverts, members tracking through reader extension."
  url "http://gunn.co.nz"
  
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources "marketplace"
      # admin.reader_search "/admin/readers/search", :controller => "readers", :action => "search"
    end
    
    map.reader_search "/admin/readers_search", :controller => "admin/readers", :action => "search"
    
    map.resources :adverts

    map.show_login_area "show_login_area", :controller => "person_sessions", :action => "show_login_area"

    map.person_login "person_login", :controller => "person_sessions", :action => "new"
    map.person_logout "person_logout", :controller => "person_sessions", :action => "destroy"
    map.resources :person_sessions
  end
  
  def activate
    Admin::ReadersController.send :include, Nzffa::Admin::ReadersControllerExtensions
    
    Reader.send :include, Nzffa::ReaderExtensions
    User.send :include, Nzffa::UserExtensions
  end

end
