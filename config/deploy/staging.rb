set :rails_env, 'staging'
set :rack_env, rails_env
set :bundle_cmd, '/home/nzffa-staging-app/.rbenv/shims/bundle'
set :whenever_command, "/home/nzffa-staging-app/.rbenv/shims/bundle exec whenever"
set :branch, 'with_rails_lts'
set :user, 'nzffa-staging-app'
set :deploy_to, "/home/#{user}/#{rails_env}"

set :solo_host, 'c.pool.nzffa.org.nz'
role :web, solo_host
role :app, solo_host
role :db,  solo_host, :primary => true
