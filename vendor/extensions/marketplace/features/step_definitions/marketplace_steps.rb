Given /^I am a member of the FFT Group$/ do
  Group.find_or_create_by_id(229, :name => 'Farm Forestry Timbers Test')
  @reader.groups << Group.find(229)
end

Given /^I already have an advert$/ do
  @advert = Advert.create(:reader_id => @reader.id,
                :title => 'existing advert',
                :body => 'you have read my advert and now you want to buy!',
                :expires_on => 30.days.from_now)
end

When /^I visit edit advert$/ do
  visit edit_advert_path @advert
end

When /^I visit new_advert_path$/ do
  visit new_advert_path
end

When /^I enter a new advert$/ do
  fill_in 'Title', :with => 'something'
  fill_in 'Body', :with => 'something non trivial.. like maths'
end

When /^I click Save$/ do
  click_on 'Save changes'
end

Then /^I should be taken to 'My Adverts'$/ do
  #URI.parse(current_url).path.should == '/specialty-timber-market/marketplace/my-adverts/'
  # another radiant issue i think.. anyway.. this will have to do
  page.should have_content 'Advert was successfully'
end

When /^I visit edit_company_lisiting$/ do
  visit edit_company_listing_adverts_path
end

When /^I enter a company listing$/ do
  fill_in 'Organisation', :with => 'Amway Express'
  select 'Auckland', :from => 'advert_reader_attributes_region'
  fill_in 'Contact person', :with => 'Roger martini'
end
