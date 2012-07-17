set :output, "#{path}/log/cron.log"

every 1.day, :at => '5:40 pm' do
  rake 'radiant:extensions:marketplace:email_warnings'
end
