Given /^a reader had a subscription that expired a week ago$/ do
  @reader = Reader.create!(:email => 'test@example.org',
                           :forename => 'jim',
                           :surname => 'david',
                           :password => 'password',
                           :password_confirmation => 'password',
                           :post_city => 'region',
                           :post_line1 => 'an address',
                           :post_province => 'province line',
                           :postcode => '12345')

  subscription = Subscription.new(:membership_type => 'casual',
                                  :belong_to_fft => true,
                                  :receive_tree_grower_magazine => false,
                                  :begins_on => Date.parse('2012-01-01'),
                                  :expires_on => 1.week.ago)
  subscription.reader = @reader
  order = CreateOrder.from_subscription(subscription)
  order.save!
  order.paid!('Online')
end

Given /^they did not create a new subscription$/ do
  #empty
end

When /^I run the expiry report$/ do
  visit expiries_admin_reports_path
end

Then /^I should see the reader in the report$/ do
  page.should have_content 'jim david'
end

Given /^they have a new active subscription$/ do
  subscription = Subscription.new(:membership_type => 'casual',
                                  :belong_to_fft => true,
                                  :receive_tree_grower_magazine => false,
                                  :begins_on => Date.today,
                                  :expires_on => 1.year.from_now)
  subscription.reader = @reader
  order = CreateOrder.from_subscription(subscription)
  order.save!
  order.paid!('Online')
end

Then /^I should not see the reader in the report$/ do
  page.should_not have_content 'jim david'
end

Given /^a reader had a subscription that expired (\d+) months? ago$/ do |arg1|
  @reader = Reader.create!(:email => 'test@example.org',
                           :forename => 'jim',
                           :surname => 'david',
                           :password => 'password',
                           :password_confirmation => 'password',
                           :post_city => 'region',
                           :post_line1 => 'an address',
                           :post_province => 'province line',
                           :postcode => '12345')

  subscription = Subscription.new(:membership_type => 'casual',
                                  :belong_to_fft => true,
                                  :receive_tree_grower_magazine => false,
                                  :begins_on => Date.parse('2001-01-01'),
                                  :expires_on => arg1.to_i.months.ago)
  subscription.reader = @reader
  order = CreateOrder.from_subscription(subscription)
  order.save!
  order.paid!('Online')
end
