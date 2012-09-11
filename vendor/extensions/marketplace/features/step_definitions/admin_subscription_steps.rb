Given /^I am a logged in admin of the system$/ do
  User.create!(:name => 'charles admin',
              :email => 'cmoney@admin.com',
              :login => 'cmoneyhoney',
              :password => 'password',
              :password_confirmation => 'password',
              :admin => true)
  visit '/admin/login'
  fill_in 'username_or_email', :with => 'cmoney@admin.com'
  fill_in 'password', :with => 'password'
  click_on 'Login'
end

Given /^there is a registered reader$/ do
  @reader = Reader.create!(:email => 'test@example.org',
                           :forename => 'jim',
                           :surname => 'david',
                           :password => 'password',
                           :password_confirmation => 'password')
end

When /^I show the reader from readers plus$/ do
  visit "/admin/readers_plus/#{@reader.id}"
end

Then /^I should see a create subscription button$/ do
  page.should have_content 'Create Subscription'
end

Then /^visit create subscription$/ do
  visit "/admin/readers/#{@reader.id}/subscriptions/new"
end

Then /^click "([^"]*)"$/ do |arg1|
  click_on arg1
end

Then /^I should see an order form$/ do
  page.should have_content 'Order Form'
end

When /^I enter the payment method and amount into the order form$/ do
  fill_in 'Amount', :with => '5'
  select 'Direct Debit', :from => 'Payment method'
  fill_in 'Paid on', :with => '2012-01-01'
end

Then /^I should see that the subscription was created successfully\.$/ do
  page.should have_content "Order created"
  page.should have_content "Reader: #{@reader.name}"
end

Then /^the order form should have an amount defined$/ do
  page.has_field?('Amount', :with => '12.5').should be_true
end

Then /^fill in a manual expiry date$/ do
  fill_in 'subscription[expires_on]', :with => '2012-12-12'

end

Then /^I should see the readers subscription$/ do
  page.should have_content 'Subscription'
end

When /^I visit admin subscriptions$/ do
  visit admin_subscriptions_path
end

Then /^I should see a table of subscriptions$/ do
  page.should have_content 'Subscriptions'
end

Then /^the reader should belong to Farm Forestry Timbers Group$/ do
  @reader.groups.should include @fft_marketplace_group
end

Given /^the registered reader has a casual subscription$/ do
  @subscription = Subscription.create!(:membership_type => 'casual',
                                       :belong_to_fft => true,
                                       :reader => @reader)

  Order.create!(:subscription => @subscription,
                :reader => @reader,
                :amount => CalculatesSubscriptionLevy.levy_for(@subscription),
                :paid_on => Date.today)

end

When /^I visit edit_admin_subscription for that sub$/ do
  visit edit_admin_subscription_path @subscription
end

When /^I add tree grower to the subscription$/ do
  choose 'Casual Membership'
  click_on 'Next'
  check 'Subscribe to NZ Tree Grower Magazine'
  click_on 'Proceed to payment'
end

Then /^I should see an order form with the upgrade amount$/ do
  page.has_field?('Amount', :with => '10.00').should be_true
end

Then /^I should see that the subscription was upgraded\.$/ do
  page.should have_content 'Order updated'
end
