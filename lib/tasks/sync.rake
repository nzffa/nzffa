def echo_and_run(cmd)
  puts cmd
  system cmd
end

desc "Make local develoment site look like the live site"
task :sync => [:environment] do
  host = 'nzffa@nzffa.org.nz'
  ssh_host = host
  path = '/home/nzffa/production/current'
  rsync_command = "rsync -az --progress"
  local_shared_path = "./shared/"


  local_shared_path = case Rails.env
  when 'development'
    "./shared/"
  when 'staging'
    Rails.root.join('../../shared/public/').to_s
  when 'production'
    Rails.root.join('../../shared/public/').to_s
  else
    raise ArgumentError, "Environment #{Rails.env.inspect} not supported"
  end

  db_config = YAML.load_file('config/database.yml')
  local_config = db_config[Rails.env]
  password_arg = "-p#{local_config['password']}" if local_config['password']

  echo_and_run "ssh #{ssh_host} \"mysqldump -u #{db_config['remote_production']["username"]} -p#{db_config['remote_production']["password"] } #{db_config['remote_production']["database"]} > ~/dump.sql\""
  echo_and_run "#{rsync_command} #{host}:~/dump.sql ./db/production_data.sql"
  echo_and_run "bundle exec rake db:drop"
  echo_and_run "bundle exec rake db:create"
  echo_and_run "mysql -u #{local_config["username"]} #{local_config["database"]} #{password_arg} < ./db/production_data.sql"
  echo_and_run "#{rsync_command} #{host}:/home/nzffa/production/shared/public/* #{local_shared_path}"
end

task :symlink => [:environment] do
  echo_and_run "ln -sf #{Rails.root.join('shared/assets')} public/"
  echo_and_run "rm public/system"
  echo_and_run "mkdir -p public/system"
  echo_and_run "ln -sf #{Rails.root.join('public/images/assets')} #{Rails.root.join('public/images/admin/assets')}"
  echo_and_run "ln -sf #{Rails.root.join('shared/assets')} public/system/"
  echo_and_run "ln -sf #{Rails.root.join('shared/attachments')} public/"
  echo_and_run "ln -sf #{Rails.root.join('shared/executive_newsletters')} public/"
  echo_and_run "ln -sf #{Rails.root.join('shared/images/design')} public/images/"
end