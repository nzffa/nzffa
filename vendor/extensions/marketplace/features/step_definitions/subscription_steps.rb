Given /^I am a registered, logged in reader$/ do

  @reader = Reader.create!(:email => 'test@example.org',
                          :forename => 'jim',
                          :surname => 'david',
                          :password => 'password',
                          :password_confirmation => 'password',
                          :post_city => 'a city',
                          :post_line1 => 'an address',
                          :post_province => 'province line',
                          :postcode => '12345')

  @reader.update_attribute(:activated_at, '2010-01-01')

  visit '/account/login'
  fill_in 'Email address', :with => 'test@example.org'
  fill_in 'Password', :with => 'password'
  click_on 'Log in'
end

Given /^FFT Marketplace membership is \$(\d+) for casual members$/ do |arg1|
  NzffaSettings.casual_member_fft_marketplace_levy = arg1.to_i
end

Given /^FFT Marketplace membership is \$(\d+) for full members$/ do |arg1|
  NzffaSettings.full_member_fft_marketplace_levy = arg1.to_i
end

Given /^Tree Grower Magazine "([^"]*)" is \$(\d+) \/ year$/ do |arg1, arg2|
  case arg1
  when 'New Zealand'
    NzffaSettings.tree_grower_magazine_within_new_zealand = arg2.to_i
  when 'Australia'
    NzffaSettings.tree_grower_magazine_within_australia = arg2.to_i
  when 'Everywhere else'
    NzffaSettings.tree_grower_magazine_everywhere_else = arg2.to_i
  else
    raise 'incorrect area for tree grower subscription destination'
  end
end

Given /^Tree Grower Magazine is \$(\d+) for full members$/ do |arg1|
  NzffaSettings.full_member_tree_grower_magazine_levy = arg1.to_i
end

Given /^admin levy is \$(\d+)$/ do |amount|
  NzffaSettings.admin_levy = amount.to_i
end

Given /^ha of trees is 0-10 for \$0, 11-40 for \$51, and 41\+ for \$120/ do 
  NzffaSettings.forest_size_levys = {'0 - 10'  => 0, 
                                     '11 - 40' => 51, 
                                     '41+'     => 120}
end

Given /^there is a branch "([^"]*)" for \$(\d+)$/ do |name, annual_levy|
  Branch.create(:name => name, :annual_levy => annual_levy)
end

Given /^there is a Tree Grower Magazine group$/ do
  @tree_grower_magazine_group = Group.create!(:name => 'Tree Grower Magazine')
  NzffaSettings.tree_grower_magazine_group_id = @tree_grower_magazine_group.id
end

Given /^there is a FFT Marketplace group$/ do
  @fft_marketplace_group = Group.create!(:name => 'Farm Forestry Timbers')
  NzffaSettings.fft_marketplace_group_id = @fft_marketplace_group.id
end

Given /^there is a Full Membership group$/ do
  @full_membership_group = Group.create!(:name => 'Full Membership')
  NzffaSettings.full_membership_group_id = @full_membership_group.id
end

Given /^Eucalyptus Action Group is \$30$/ do
  @eucalyptus_action_group_group = Group.create!(:name => 'Eucalyptus Action Group Group')

  @eucalyptus_action_group = ActionGroup.create!(:name => 'Eucalyptus Action Group', 
                                                 :group => @eucalyptus_action_group_group,
                                                 :annual_levy => 30)

end

Then /^I should belong to the Tree Grower Magazine group$/ do
  @reader.groups.should include @tree_grower_magazine_group
end

Then /^I should belong to the FFT Marketplace group$/ do
  @reader.groups.should include @fft_marketplace_group
end

Then /^I should belong to the Full Membership group$/ do
  @reader.groups.should include @full_membership_group
end

Then /^I should belong to the Eucalyptus Action group$/ do
  @reader.reload
  @reader.groups.should include @eucalyptus_action_group_group
end

Then /^I should belong to the NZFFA Members Newsletter group$/ do
  @reader.reload
  @reader.group_ids.should include NzffaSettings.nzffa_members_newsletter_group_id
end

When /^I visit new subscription$/ do
  visit new_subscription_path
end

When /^select a Full Membership$/ do
  choose 'subscription_membership_type_full'
end

When /^click Next$/ do
  click_on 'Next'
end

When /^wait a bit$/ do
  sleep 10
end

Then /^wait for ages$/ do
  sleep 60
end

Given /^the date is "([^"]*)"$/ do |arg1|
  Timecop.travel(Date.parse(arg1))
end

    
Given /^I signup with 0-10ha, main branch North Otago, and join FFT$/ do 
  visit new_subscription_path
  choose 'subscription_membership_type_full'
  click_on 'Next'
  within '#ha_of_planted_trees' do
    choose '0 - 10ha'
  end
  select 'North Otago', :from => 'subscription_main_branch_name'
  check 'subscription_belong_to_fft'
end

Then /^the Subscription Price should be "([^"]*)"$/ do |arg1|
  find('#price').should have_content arg1
end

Then /^the expiry date should be "([^"]*)"$/ do |arg1|
  find('#expires_on').should have_content Date.parse(arg1).strftime('%e %B %Y')
end


Given /^have a look$/ do
  save_and_open_page
end

Given /^there is a FFT group to identify FFT advertisers$/ do 
  fft_group = Group.create(:name => 'Farm Forestry Timbers')
  NzffaSettings.fft_group_id = fft_group.id
end

Given /^I have configured an FFT subscription$/ do
  NzffaSettings.casual_member_fft_marketplace_levy = 50
  visit new_subscription_path
  choose 'Casual Membership'
  click_on 'Next'
  check 'subscription_belong_to_fft'
  choose 'End of this year'
end

When /^I click 'Proceed to payment'$/ do
  click_on 'Proceed to payment'
end

Then /^I should be forwarded to payment express$/ do
  #puts current_url
end

Then /^should see I am being charged the full amount$/ do
  page.should have_content '$50.00'
end

When /^I enter my credit card details$/ do
  fill_in 'CardNum', :with => '4111111111111111'
  fill_in 'ExMnth', :with => '12'
  fill_in 'ExYr', :with => '20'
  fill_in 'NmeCard', :with => 'Testbert Testrie'
  fill_in 'Cvc2', :with => '911'
  click_on 'submitImageButton' # or SUBMIT
end

Then /^I should see that payment was successful$/ do
  page.should have_content 'APPROVED'
  click_on 'Click Here to Proceed to the Next step'
  sleep 10
end

Then /^I should have access to place an ad in the FFT Marketplace$/ do
 Group.find(NzffaSettings.fft_group_id).readers.should include @reader
end

Given /^I created a casual fft subscription at the start of the year$/ do
  subscription = Subscription.new(:membership_type => 'casual',
                                  :belong_to_fft => true,
                                  :receive_tree_grower_magazine => false,
                                  :begins_on => Date.parse('2012-01-01'),
                                  :expires_on => Date.parse('2012-12-31'))
  @old_subscription = subscription
  subscription.reader = @reader
  order = CreateOrder.from_subscription(subscription)
  order.save!
  order.paid!('Online')
end

When /^I visit "([^"]*)"$/ do |path|
  visit path
end

Then /^my original subscription should be cancelled$/ do
  @old_subscription.reload
  @old_subscription.active?.should be_false
end

Then /^my new subscription should be active$/ do
  Subscription.active_subscription_for(@reader).should be_active
end

Then /^I should see the subscription details$/ do
  page.should have_content 'Begins on'
  page.should have_content 'Expires on'
  page.should have_content 'Farm Forestry Timbers Marketplace'
  page.should have_content 'Tree Grower Magazine'
end

When /^change number of copies to (\d+)$/ do |arg1|
  fill_in "Number of copies", :with => '2'
end

Then /^I should be subscribed to get (\d+) copies of NZ Tree Grower Magazine$/ do |arg1|
  Subscription.active_subscription_for(@reader).nz_tree_grower_copies.should == arg1.to_i
end

Given /^I have an unpaid subscription$/ do
  subscription = Subscription.new(:membership_type => 'casual',
                                  :belong_to_fft => true,
                                  :receive_tree_grower_magazine => false,
                                  :begins_on => Date.parse('2012-01-01'),
                                  :expires_on => Date.parse('2012-12-31'))
  subscription.reader = @reader
  order = CreateOrder.from_subscription(subscription)
  order.save!
end

Then /^I should see a Make Payment link$/ do
  save_and_open_page
  page.should have_link 'Make Payment'
end

Then /^I should see a Cancel Subscription link$/ do
  page.should have_link 'Cancel Subscription'
end

Then /^the page should say thank you$/ do
  page.should have_content 'Thank you. Your payment was successful and your subscription is now active.'
end

Given /^there is a members newsletter group$/ do
  @members_newsletter_group = Group.create!(:name => 'members newsletter group')
  NzffaSettings.nzffa_members_newsletter_group_id = @members_newsletter_group.id
end

Then /^I should belong to the Tree Grower Magazine Australia group$/ do
  @reader.reload
  @reader.group_ids.should include NzffaSettings.tree_grower_magazine_australia_group_id
end

Given /^there is a Tree Grower Magazine Australia group$/ do
  group = Group.create(:name => 'Tree grower magazine australia')
  NzffaSettings.tree_grower_magazine_australia_group_id = group.id
end
