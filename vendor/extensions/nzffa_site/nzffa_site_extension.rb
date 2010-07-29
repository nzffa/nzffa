class NzffaSiteExtension < Radiant::Extension
  version "1.0"
  description "Home for all dynamic NZFFA content, both person and admin side. Has adverts, members and wiki stuff."
  url "http://gunn.co.nz"
  
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources "marketplace"
    end
    
    map.resources :adverts

    map.show_login_area "show_login_area", :controller => "person_sessions", :action => "show_login_area"

    map.person_login "person_login", :controller => "person_sessions", :action => "new"
    map.person_logout "person_logout", :controller => "person_sessions", :action => "destroy"
    map.resources :person_sessions
    
  end
  
  def activate
    # admin.tabs.add "Marketplace", "/admin/marketplace", :before => "Snippets", :visibility => [:admin]
  end

end
