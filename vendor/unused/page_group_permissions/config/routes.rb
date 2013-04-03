ActionController::Routing::Routes.draw do |map|
  if Group.table_exists?
    map.namespace :admin do |admin|
      admin.resources :groups
    end
    map.with_options(:controller => 'admin/groups') do |group|
      group.remove_admin_group 'admin/groups/:id/remove', :action => 'remove', :conditions => {:method => :get}
      group.add_member_admin_group 'admin/groups/:id/add_member', :action => 'add_member', :conditions => {:method => :post}
      group.remove_member_admin_group 'admin/groups/:group_id/remove_member/:id', :action => 'remove_member'
    end
  end
end