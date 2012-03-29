set :deploy_to, "/home/#{user}/staging"

set :solo_host, 'nzffa.enspiral.info'
role :web, solo_host
role :app, solo_host
role :db,  solo_host, :primary => true

set :use_sudo, false

set :deploy_env, 'production'
set :git_enable_submodules, 1
set :ssh_options, {:forward_agent => true}
