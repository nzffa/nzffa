set :rails_env, 'production'
set :rack_env, rails_env
set :bundle_cmd, '/home/nzffa-app/.rbenv/shims/bundle'
set :whenever_command, "/home/nzffa-app/.rbenv/shims/bundle exec whenever"
set :branch, 'production'
set :deploy_to, "/home/#{user}/#{rails_env}"

set :solo_host, 'c.pool.nzffa.org.nz'
role :web, solo_host
role :app, solo_host
role :db,  solo_host, :primary => true
