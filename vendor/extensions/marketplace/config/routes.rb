ActionController::Routing::Routes.draw do |map|
  map.resources :adverts, 
    :collection => {
      :edit_company_listing => :get, 
      :index_table => :get, 
      :my_adverts => :get
    },
    :member => {
      :renew => :put
    }

  map.namespace :admin do |admin|
    admin.resources :adverts, :except => [:new, :create]
  end

  map.show_login_area "show_login_area", :controller => "person_sessions", :action => "show_login_area"
  map.person_login "person_login", :controller => "person_sessions", :action => "new"
  map.person_logout "person_logout", :controller => "person_sessions", :action => "destroy"
  map.resources :person_sessions
end
