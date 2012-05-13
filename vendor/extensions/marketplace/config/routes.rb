ActionController::Routing::Routes.draw do |map|
  map.resources :adverts

  map.namespace :admin do |admin|
    admin.resources :marketplace
  end

  map.show_login_area "show_login_area", :controller => "person_sessions", :action => "show_login_area"
  map.person_login "person_login", :controller => "person_sessions", :action => "new"
  map.person_logout "person_logout", :controller => "person_sessions", :action => "destroy"
  map.resources :person_sessions
end