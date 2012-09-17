set :output, "#{path}/log/cron.log"

every 1.day do
  rake 'radiant:extensions:marketplace:email_warnings'
  rake 'radiant:extensions:marketplace:subscription_email_warnings'
  rake 'radiant:extensions:marketplace:subscription_expiry'
end
