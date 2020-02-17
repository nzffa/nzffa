env :PATH, ENV['PATH']
set :output, "#{path}/log/cron.log"
set :job_template, nil

every 1.day do
  rake 'radiant:extensions:marketplace:email_warnings'
end
every '42 0 14 11 *' do
  rake 'radiant:extensions:nzffa:subscription_email_warnings'
end
every '2 7 * * 0' do
  rake 'radiant:extensions:nzffa:synchronize_xero_payments'
end
