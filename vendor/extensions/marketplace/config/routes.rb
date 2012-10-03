ActionController::Routing::Routes.draw do |map|
  map.resources :subscriptions, :except => [:destroy, :edit, :update], 
    :collection => { :quote_new => :post, 
                     :quote_upgrade => :post,
                     :modify => :get,
                     :upgrade => :put,
                     :cancel => :post}

  map.resources :adverts,
    :collection => {
      :edit_company_listing => :get,
      :index_table => :get,
      :my_adverts => :get,
    },
    :member => {
      :renew => :put,
      :email => [:get]
    }

  map.resources :orders, :only => [], 
    :member => { :make_payment => :get}, 
    :collection => { :payment_finished => :get }

  map.reader_dashboard '/membership/dashboard', :controller => :membership, :action => :dashboard
  map.register '/membership/register', :controller => :membership, :action => :register
  map.join_fft_button '/membership/join-fft-button', :controller => :membership, :action => :join_fft_button
  map.join_fft '/membership/join-fft', :controller => :membership, :action => :join_fft

  map.namespace :admin do |admin|
    admin.resources :reports, :only => :index, :collection => {:payments => :get, :allocations => :get}
    admin.resources :subscriptions
    admin.resources :adverts, :except => [:new, :create]
    admin.resources :readers_plus, :except => [:new, :create]
    admin.resources :orders
    admin.resources :readers, :only => [] do |readers|
      readers.resources :orders, :only => :index
      readers.resources :subscriptions
    end
  end

  map.show_login_area "show_login_area", :controller => "person_sessions", :action => "show_login_area"
  map.person_login "person_login", :controller => "person_sessions", :action => "new"
  map.person_logout "person_logout", :controller => "person_sessions", :action => "destroy"
  map.resources :person_sessions
end
