set :rails_env, 'staging'
set :rack_env, rails_env
set :branch, 'staging'
set :deploy_to, "/home/#{user}/#{rails_env}"

set :solo_host, 'delta.enspiral.info'
role :web, solo_host
role :app, solo_host
role :db,  solo_host, :primary => true

