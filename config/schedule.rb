env :PATH, ENV['PATH']
set :output, "#{path}/log/cron.log"
set :job_template, nil

every 1.day do
  rake 'radiant:extensions:marketplace:email_warnings'
  rake 'radiant:extensions:marketplace:subscription_email_warnings'
  rake 'radiant:extensions:marketplace:subscription_expiry'
end
