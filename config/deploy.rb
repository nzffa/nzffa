require "bundler/capistrano"
require 'whenever/capistrano'
require 'capistrano/ext/multistage'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false

set :stages, %w(production staging)
set :default_stage, "staging"

set :application, "nzffa"
set :user, "nzffa"
set :group, "www-data"

set :scm, :git
set :repository, "git@github.com:nzffa/nzffa.git"
#set :deploy_via, :remote_cache
set :bundle_without, [:development, :test, :cucumber]
set :bundle_flags, '--deployment --quiet --full-index'
set :whenever_command, "bundle exec whenever"

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:update_code", "custom:symlink"

namespace(:custom) do
  task :symlink, :roles => :app do
    link_from_shared_to_current('config')
    run "ln -nfs #{shared_path}/public/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/public/attachments #{release_path}/public/attachments"
    run "ln -nfs #{shared_path}/public/executive_newsletters #{release_path}/public/executive_newsletters"
    run "ln -nfs #{shared_path}/public/images/design #{release_path}/public/images/design"
    run "ln -nfs #{release_path}/public/images/assets #{release_path}/public/images/admin/assets"
    run "ln -nfs #{shared_path}/post_attachments #{release_path}/post_attachments"
    run "rm -f #{release_path}/config.ru"
  end
end

def link_from_shared_to_current(path, dest_path = path)
  src_path = "#{shared_path}/#{path}"
  dst_path = "#{release_path}/#{dest_path}"
  run "for f in `ls #{src_path}/` ; do ln -nsf #{src_path}/$f #{dst_path}/$f ; done"
end

# task :setup_env do
#   run "RACK_ENV=#{rails_env}"
#   run "RAILS_ENV=#{rails_env}"
#
#   run "echo 'RackEnv #{rails_env}' >> #{File.join(current_path, '.htaccess')}"
#   run "echo 'RailsEnv #{rails_env}' >> #{File.join(current_path, '.htaccess')}"
# end
# before "restart", "setup_env"


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'airbrake-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'airbrake/capistrano'
