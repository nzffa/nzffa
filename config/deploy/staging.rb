set :rails_env, 'staging'
set :rack_env, rails_env
set :branch, 'staging'
set :deploy_to, "/var/www/vhosts/nzffa.avlux.net/#{rails_env}"
set :user, "nzffa1"

set :solo_host, 'nzffa.avlux.net'
role :web, solo_host
role :app, solo_host
role :db,  solo_host, :primary => true

