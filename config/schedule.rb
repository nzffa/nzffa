set :output, "#{path}/log/cron.log"

every 1.day do
  rake 'radiant:extensions:marketplace:email_warnings'
end
