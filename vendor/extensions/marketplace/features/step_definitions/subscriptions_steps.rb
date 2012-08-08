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

Given /^admin levy is \$(\d+)$/ do |amount|
  NzffaSettings.set :admin_levy, amount
end

Given /^ha of trees is 0-10 for \$0, 11-40 for \$51, and 41\+ for \$120/ do 
  NzffaSettings.set :forest_size_levys, [['0 - 10', 0], ['11 - 40', 51], ['41+', 120]]
end

Given /^there is a branch "([^"]*)" for \$(\d+)$/ do |arg1, arg2|
  Branch.create(:name => arg1, :levy => arg2)
end

Given /^tree grower subscription costs \$(\d+) per year for members$/ do |arg1|
  NzffaSettings.set :tree_grower_for_members, arg1
end

When /^I visit new subscription$/ do
  visit new_subscription_path
end

When /^select an NZFFA Membership$/ do
  choose 'NZFFA Membership'
end

When /^click Next$/ do
  click_on 'Next'
end

When /^configure the subscription as a branch member$/ do
  within '#ha_of_planted_trees' do
    choose '0 - 10ha'
  end
  select 'Otago', :from => 'subscription_main_branch'
  check 'subscription_belong_to_fft'
  click_on 'Proceed to payment'
end

When /^click create subscription$/ do
  pending # express the regexp above with the code you wish you had
end
