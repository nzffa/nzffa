set :output, "#{path}/log/cron.log"

every 1.day, :at => '5:45 am' do
  rake 'radiant:extensions:marketplace:email_warnings'
end
