Given /^I have configured a subscription$/ do
  NzffaSettings.fft_marketplace_membership_only = 50
  visit new_subscription_path
  choose 'FFT Marketplace Membership'
  click_on 'Next'
  choose 'Full year'
end

When /^I click 'Proceed to payment'$/ do
  click_on 'Proceed to payment'
end

Then /^should see I am being charged the full amount$/ do
  page.should have_content 'Amount: $50.00'
end

When /^I enter my credit card details$/ do
  fill_in 'Credit Card Number', :with => '1234 1234 1234 1234'
end

Then /^I should see that payment was successful$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^my subscription should be activated$/ do
  pending # express the regexp above with the code you wish you had
end
