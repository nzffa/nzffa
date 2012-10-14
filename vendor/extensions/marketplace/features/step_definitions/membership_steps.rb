Given /^there is a fft newsletter group$/ do
  g = Group.create!(:name => 'fft newsletter')
  NzffaSettings.fft_newsletter_group_id = g.id
end

Given /^there is a full members newsletter group$/ do
  g = Group.create!(:name => 'nzffa members newsletter')
  NzffaSettings.nzffa_members_newsletter_group_id = g.id
end

When /^I visit membership register$/ do
  visit register_membership_path
end

When /^enter my personal details$/ do
  fill_in 'reader_forename', :with => 'Jim'
  fill_in 'reader_surname', :with => 'Davidson'
  fill_in 'reader_phone', :with => '03477777'
  fill_in 'reader_mobile', :with => '021 717 491'
  fill_in 'reader_email', :with => 'jim@davidson.com'
  fill_in 'reader_password', :with => 'password'
  fill_in 'reader_password_confirmation', :with => 'password'
end

When /^update my personal details$/ do
  fill_in 'reader_forename', :with => 'Jim'
  fill_in 'reader_surname', :with => 'Davidson'
  fill_in 'reader_phone', :with => '03477777'
  fill_in 'reader_mobile', :with => '021 717 491'
  fill_in 'reader_email', :with => 'jim@davidson.com'
end

Given /^I belong to the full membership group$/ do
  @reader.groups << Group.find(NzffaSettings.full_membership_group_id)
end

Then /^I should belong to the Farm Forestry Timbers Newsletter Group$/ do
  @reader = Reader.find_by_email('jim@davidson.com')
  @reader.group_ids.should include NzffaSettings.fft_newsletter_group_id
end

Then /^I should not belong to NZFFA Members Newsletter group$/ do
  @reader.group_ids.should_not include NzffaSettings.nzffa_members_newsletter_group_id
end

Then /^I should get a registration email$/ do
  email = ActionMailer::Base.deliveries.last
  #raise (email.methods - Object.methods).sort.inspect
  email.to.should include 'jim@davidson.com'
  email.subject.should == 'Thanks for registering with the NZFFA'
end

Then /^I should be asked if I want to buy a subscription$/ do
  current_path.should == MembershipController::AFTER_SIGNUP_PATH
end

Then /^I should be taken to new subscription page$/ do
  current_path.should == new_subscription_path
end

Then /^I should see my details in the form$/ do
  find_field('reader_forename').value.should == 'Jim'
  find_field('reader_surname').value.should == 'Davidson'
  find_field('reader_phone').value.should == '03477777'
  find_field('reader_mobile').value.should == '021 717 491'
  find_field('reader_email').value.should == 'jim@davidson.com'
end

When /^I click "([^"]*)"$/ do |arg1|
  click_on arg1
end

Then /^I should not see the password fields$/ do
  page.should_not have_field 'password'
end

