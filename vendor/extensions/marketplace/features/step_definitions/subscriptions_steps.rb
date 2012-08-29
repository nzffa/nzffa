Given /^I am a registered, logged in reader$/ do

  @reader = Reader.create(:email => 'test@example.org',
                          :forename => 'jim',
                          :surname => 'david',
                          :password => 'password',
                          :password_confirmation => 'password',
                          :activated_at => nil)
  visit '/account/login'
  fill_in 'Nickname or email address', :with => 'test@example.org'
  fill_in 'Password', :with => 'password'
  click_on 'Log in'

end

Given /^admin levy is \$(\d+)$/ do |amount|
  NzffaSettings.admin_levy = amount
end

Given /^ha of trees is 0-10 for \$0, 11-40 for \$51, and 41\+ for \$120/ do 
  NzffaSettings.forest_size_levys = {'0 - 10'  => 0, 
                                     '11 - 40' => 51, 
                                     '41+'     => 120}
end

Given /^there is a branch "([^"]*)" for \$(\d+)$/ do |name, annual_levy|
  Branch.create(:name => name, :annual_levy => annual_levy)
end

Given /^Farm Foresty Timbers Marketplace membership is \$(\d+)$/ do |arg1|
  NzffaSettings.fft_marketplace_membership = arg1
end

Given /^tree grower magazine subscription costs \$(\d+) per year for members$/ do |arg1|
  NzffaSettings.tree_grower_for_members = arg1
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


#When /^configure the subscription as a branch member$/ do
  #within '#ha_of_planted_trees' do
    #choose '0 - 10ha'
  #end
  #select 'Otago', :from => 'subscription_main_branch_name'
  #check 'subscription_belong_to_fft'
  #click_on 'Proceed to payment'
#end

When /^click create subscription$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^wait for ages$/ do
  sleep 5
end

Given /^the date is "([^"]*)"$/ do |arg1|
  Timecop.travel(Date.parse(arg1))
end

    
Given /^I signup with 0-10ha, main branch North Otago, and join FFT$/ do 
  visit new_subscription_path
  choose 'NZFFA Membership'
  click_on 'Next'
  within '#ha_of_planted_trees' do
    choose '0 - 10ha'
  end
  select 'North Otago', :from => 'subscription_main_branch_name'
  check 'subscription_belong_to_fft'
end

Then /^the Subscription Fee should be "([^"]*)"$/ do |arg1|
  find('#total_fee').should have_content arg1
end

Then /^the expiry date should be "([^"]*)"$/ do |arg1|
  find('#expires_on').should have_content Date.parse(arg1).strftime('%e %B %Y')
end

#When /^I select "([^"]*)"$/ do |arg1|
  #pending # express the regexp above with the code you wish you had
#end
#
Given /^FFT Marketplace membership only is \$(\d+)\/year$/ do |arg1|
  NzffaSettings.fft_marketplace_membership_only = 50
end

Given /^Tree Grower Magazine "([^"]*)" is \$(\d+) \/ year$/ do |arg1, arg2|
  case arg1
  when 'Within New Zealand'
    NzffaSettings.tree_grower_magazine_within_new_zealand = arg2
  when 'Within Australia'
    NzffaSettings.tree_grower_magazine_within_australia = arg2
  when 'Everywhere else'
    NzffaSettings.tree_grower_magazine_everywhere_else = arg2
  end
end

Given /^have a look$/ do
  save_and_open_page
end
