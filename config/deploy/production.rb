set :rails_env, 'production'
set :rack_env, rails_env
set :branch, 'production'
set :deploy_to, "/home/#{user}/#{rails_env}"

set :solo_host, '119.47.122.22'
role :web, solo_host
role :app, solo_host
role :db,  solo_host, :primary => true


