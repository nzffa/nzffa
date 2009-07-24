set :application, "NZFFA"
set :scm, :git

set :keep_releases, 4
set :repository, "/home/admin/repos/NZFFA.git"
set :domain, "vint.co.nz"


set :deploy_via, :remote_cache
set :deploy_to, "/home/admin/public_html/NZFFA.org.nz"


set :mongrel_conf, "#{release_path}/config/mongrel_cluster.yml" # must come after 'deploy_to'



ssh_options[:paranoid] = false

set :runner, "mongrel"
set :user, "admin"
set :use_sudo, false

role :app, domain
role :web, domain
role :db,  domain, :primary => true


namespace :deploy do
  desc "Add symlinks to the database.yml file, and public assets."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/public/attachments #{release_path}/public/attachments"
    run "ln -nfs #{shared_path}/public/assets #{release_path}/public/assets"
  end
end

after 'deploy:symlink', 'deploy:symlink_shared'

set :mongrel_clean, true