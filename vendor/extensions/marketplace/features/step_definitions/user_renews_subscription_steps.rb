Given /^I have a full subscription for the current year$/ do
  subscription = Subscription.new(:membership_type => 'full',
                                  :begins_on => Date.parse('2013-01-01'),
                                  :expires_on => Date.parse('2013-12-31'))
  subscription.reader = @reader
  order = CreateOrder.from_subscription(subscription)
  order.save!
  order.paid!('Online')
end

When /^I visit membership details$/ do
  visit membership_details_path
end

When /^click to renew my subscription for (\d+)$/ do |arg1|
  click_on "Renew subscription"
end

When /^use the same subscription details$/ do
  # nothing
end

Then /^I should have a subscription for the current year and the next year$/ do
  @reader.subscriptions.map(&:begins_on).map(&:year).sort.should == [2013,2014]
end

Then /^I should have a subscription for (\d+) all ready to go\.$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

