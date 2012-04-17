require "bundler/capistrano"

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "nzffa"
set :user, "nzffa"
set :group, "www-data"

set :scm, :git
set :repository, "git://github.com/enspiral/nzffa.git"
set :branch, $1 if `git branch` =~ /\* (\S+)\s/m
set :deploy_via, :remote_cache

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
  end
end

def link_from_shared_to_current(path, dest_path = path)
  src_path = "#{shared_path}/#{path}"
  dst_path = "#{release_path}/#{dest_path}"
  run "for f in `ls #{src_path}/` ; do ln -nsf #{src_path}/$f #{dst_path}/$f ; done"
end