# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class NzffaSiteExtension < Radiant::Extension
  version "1.0"
  description "Home for all dynamic NZFFA content, both user and admin side. Has adverts, members and wiki stuff."
  url "http://gunn.co.nz"
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :marketplace
    end
    map.connect "marketplace", :controller => "adverts"
  end
  
  def activate
    admin.tabs.add "Marketplace", "/admin/marketplace", :before => "Snippets", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Nzffa Site"
  end
  
end
