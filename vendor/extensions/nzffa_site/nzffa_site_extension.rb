# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'
# require File.join(File.dirname(__FILE__), '/vendor/gems/authlogic-2.0.13/init.rb')

class NzffaSiteExtension < Radiant::Extension
  version "1.0"
  description "Home for all dynamic NZFFA content, both person and admin side. Has adverts, members and wiki stuff."
  url "http://gunn.co.nz"
  
  # require "authlogic"
  # require "paperclip"
  
  define_routes do |map|
    # map.namespace :admin, :member => { :remove => :get } do |admin|
    #   admin.resources :marketplace
    # end
    
    # map.connect "marketplace", :controller => "adverts"
    # map.connect "", :controller => "adverts"
    
    map.namespace :admin do |admin|
      # admin.connect "marketplace", :controller => "admin/marketplace"
      admin.resources "marketplace"
    end
    
    # Don't think we want these:
    # map.resources :magazines
    # map.resources :presidentials

    # figure out these later:
    # map.resources :person_branch_roles
    # map.resources :roles
    # map.resources :branches
    
    # map.resources :people
    

    # map.connect "adverts/list", :controller => "adverts", :action => "list"
    map.resources :adverts

    map.show_login_area "show_login_area", :controller => "person_sessions", :action => "show_login_area"

    map.person_login "person_login", :controller => "person_sessions", :action => "new"
    map.person_logout "person_logout", :controller => "person_sessions", :action => "destroy"
    map.resources :person_sessions

    
    # shouldn't be root
    # map.root :controller => "adverts"  
    
    
  end
  
  def activate
    admin.tabs.add "Marketplace", "/admin/marketplace", :before => "Snippets", :visibility => [:admin]
  end
  
  def deactivate
    # admin.tabs.remove "Nzffa Site"
  end
  
end