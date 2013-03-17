Given /^there is an Otago branch and group and a member$/ do
  @group = Group.create!(:name => 'Otago')
  @branch = Branch.create!(:name => 'Otago', :group_id => @group.id)
  @member = Reader.create!(:email => 'member@example.org',
                           :forename => 'member',
                           :surname => 'of the group',
                           :post_city => 'city',
                           :post_line1 => 'something',
                           :post_province => 'someting province',
                           :postcode => 'postcode',
                           :password => 'password',
                           :password_confirmation => 'password')

  @member.groups << @group

  @outsider = Reader.create!(:email => 'outsider@example.org',
                           :forename => 'outsider',
                           :surname => 'of the group',
                           :post_city => 'city',
                           :post_line1 => 'something',
                           :post_province => 'someting province',
                           :postcode => 'postcode',
                           :password => 'password',
                           :password_confirmation => 'password')
end

Given /^I am logged in as the Otago group secretary$/ do
  @reader = Reader.create!(:email => 'test@example.org',
                           :forename => 'jim',
                           :surname => 'david',
                           :post_city => 'city',
                           :post_line1 => 'something',
                           :post_province => 'someting province',
                           :postcode => 'postcode',
                           :password => 'password',
                           :password_confirmation => 'password')
  @reader.update_attribute(:activated_at, '2010-01-01')

  visit '/account/login'
  fill_in 'Email address', :with => 'test@example.org'
  fill_in 'Password', :with => 'password'
  click_on 'Log in'

  @reader.groups << @group
  @secretary_group = Group.new(:name => 'secretarys')
  @secretary_group.id = NzffaSettings.secretarys_group_id
  @secretary_group.save!
  @reader.is_secretary = true
  @reader.groups.should include(@secretary_group)
end

When /^I visit the Otago branch secretary index$/ do
  visit "/branch_admin/#{@branch.id}"
end

Then /^I should see a list of readers who are members of the otago branch$/ do
  page.should have_content 'member of the group'
  page.should_not have_content 'member of another group'
end

Given /^I am logged in as a reader who is not a secretary$/ do
  @reader = Reader.create!(:email => 'test@example.org',
                           :forename => 'jim',
                           :surname => 'david',
                           :post_city => 'city',
                           :post_line1 => 'something',
                           :post_province => 'someting province',
                           :postcode => 'postcode',
                           :password => 'password',
                           :password_confirmation => 'password')
  @reader.update_attribute(:activated_at, '2010-01-01')

  visit '/account/login'
  fill_in 'Email address', :with => 'test@example.org'
  fill_in 'Password', :with => 'password'
  click_on 'Log in'
end

Then /^I should be redirected somewhere$/ do
  page.should_not have_content 'member of the group'
end

When /^I click edit next to the first reader in the list$/ do
  save_and_open_page
  click_on 'Edit'
end

When /^I change their name$/ do
  fill_in 'Forename', :with => 'updated forename'
end

Then /^I should see that the reader was updated$/ do
  page.should have_content 'Member Updated'

end
