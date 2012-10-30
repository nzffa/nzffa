Given /^there is a reader with a treegrower subscription for (\d+)$/ do |arg1|

  @reader = Reader.create!(:email => 'test@example.org',
                          :forename => 'jim',
                          :surname => 'david',
                          :password => 'password',
                          :password_confirmation => 'password',
                          :post_line1 => 'an address',
                          :post_province => 'province line',
                          :postcode => '12345')

  @reader.update_attribute(:activated_at, '2010-01-01')

  subscription = Subscription.new(:membership_type => 'casual',
                                  :belong_to_fft => false,
                                  :receive_tree_grower_magazine => true,
                                  :begins_on => Date.parse('2012-01-01'),
                                  :expires_on => Date.parse('2012-12-31'))
  @old_subscription = subscription
  subscription.reader = @reader
  order = CreateOrder.from_subscription(subscription)
  order.save!
  order.paid!('Online')
end

When /^we run the tree grower report$/ do
  visit deliveries_admin_reports_path
end

Then /^the reader name and postal address should be listed$/ do
  page.should have_content "jim david"
  page.should have_content "an address"
  page.should have_content "province line"
  page.should have_content "12345"
end

Then /^the reader should get (\d+) copy of tree grower magazine$/ do |arg1|
  page.should have_content "1 copy"
end
