Before('reader_logged_in') do
  @reader = Reader.create(:forename => 'jim', 
                          :surname => 'david',
                          :email => 'jim@example.org',
                          :password => 'password',
                          :password_cofirmation => 'password')
  visit '/account/login'
  fill_in 'reader_session_email', :with => 'jim@example.org'
  fill_in 'reader_session_password', :with => 'jim@example.org'
  click_on 'Log in'
end
