def echo_and_run(cmd)
  puts cmd
  system cmd
end

desc "Make local develoment site look like the live site"
task :sync => [:environment] do
  host = 'admin@nzffa.org.nz'
  port = '36633'
  ssh_host = "-p #{port} #{host}"
  path = '/home/admin/sites/nzffa.org.nz/current'
  rsync_command = "rsync -az --progress -e 'ssh -p #{port}'"
  local_shared_path = "./shared/"

  local_shared_path = case Rails.env
  when 'development'
    "./shared/"
  when 'staging'
    "./../shared/public/"
  else
    raise ArgumentError, "Environment #{Rails.env.inspect} not supported"
  end

  db_config = YAML.load_file('config/database.yml')
  local_config = db_config[Rails.env]
  password_arg = "-p#{local_config['password']}" if local_config['password']

  echo_and_run "ssh #{ssh_host} \"mysqldump -u #{db_config['production']["username"]} -p#{db_config['production']["password"] } #{db_config['production']["database"]} > ~/dump.sql\""
  echo_and_run "#{rsync_command} #{host}:~/dump.sql ./db/production_data.sql"
  echo_and_run "mysql -u #{local_config["username"]} #{local_config["database"]} #{password_arg} < ./db/production_data.sql"
  echo_and_run "#{rsync_command} #{host}:/home/admin/sites/nzffa.org.nz/shared/public/* #{local_shared_path}"
end