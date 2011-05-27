load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }


set :app_name,     "nzffa.org.nz"

# ================================

set :application, "nzffa.org.nz"
 
role :app, application
role :web, application
role :db,  application, :primary => true
 
set :scm, :git
set :branch,      "origin/master"


set :user, "admin"
set :port, 36633


set :base_path,    "/home/admin/sites/#{app_name}"
set :repository,   "#{base_path}/#{app_name}.git"
set :current_path, "#{base_path}/current"
set :shared_path,  "#{base_path}/shared"

set :local_base_path,    File.expand_path("../..", __FILE__)
set :local_repository,   "#{local_base_path}/#{app_name}.git"
set :local_current_path, "#{local_base_path}/current"
set :local_shared_path,  "#{local_base_path}/shared"
