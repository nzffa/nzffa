set :rails_env, 'staging'
set :rack_env, rails_env
set :deploy_to, "/home/#{user}/#{rails_env}"

set :solo_host, 'nzffa.enspiral.info'
role :web, solo_host
role :app, solo_host
role :db,  solo_host, :primary => true

set :use_sudo, false

set :git_enable_submodules, 1
set :ssh_options, {:forward_agent => true}

task :setup_env do
  run "RACK_ENV=#{rails_env}"
  run "RAILS_ENV=#{rails_env}"

  run "echo 'RackEnv #{rails_env}' >> #{File.join(current_path, '.htaccess')}"
  run "echo 'RailsEnv #{rails_env}' >> #{File.join(current_path, '.htaccess')}"
end

before "restart", "setup_env"
