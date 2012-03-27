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

  db_config = YAML.load_file('config/database.yml')

  # echo_and_run "ssh #{ssh_host} \"mysqldump -u #{db_config['production']["username"]} -p#{db_config['production']["password"] } #{db_config['production']["database"]} > ~/dump.sql\""
  # echo_and_run "#{rsync_command} #{host}:~/dump.sql ./db/production_data.sql"
  # echo_and_run "mysql -u #{db_config['development']["username"]} #{db_config['development']["database"]} < ./db/production_data.sql"
  echo_and_run "#{rsync_command} #{host}:/home/admin/sites/nzffa.org.nz/shared/public/* ./shared/"
end