Given /^I am a registered, logged in reader$/ do

  @reader = Reader.create(:email => 'test@example.org',
                          :forename => 'jim',
                          :surname => 'david',
                          :password => 'password',
                          :password_confirmation => 'password',
                          :activated_at => DateTime.now)
  visit '/'
  fill_in 'Email', :with => 'test@example.org'
  fill_in 'Password', :with => 'password'
  click_on 'Login'

end

When /^I visit new subscription$/ do
  visit new_subscription_path
end

When /^configure the subscription as a branch member$/ do
  pending # express the regexp above with the code you wish you had
end

When /^click create subscription$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see 'Subscription created successfully'$/ do
  pending # express the regexp above with the code you wish you had
end
