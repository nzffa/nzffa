Given /^there is a FFT group to identify FFT advertisers$/ do 
  fft_group = Group.create(:name => 'Farm Forestry Timbers')
  NzffaSettings.fft_group_id = fft_group.id
end

Given /^I have configured an FFT subscription$/ do
  NzffaSettings.fft_marketplace_membership_only = 50
  visit new_subscription_path
  choose 'FFT Marketplace Membership'
  click_on 'Next'
  choose 'Full year'
end

When /^I click 'Proceed to payment'$/ do
  click_on 'Proceed to payment'
end

Then /^I should be forwarded to payment express$/ do
  puts current_url
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
end

Then /^I should have access to place an ad in the FFT Marketplace$/ do
 Group.find(NzffaSettings.fft_group_id).readers.should include @reader
end

