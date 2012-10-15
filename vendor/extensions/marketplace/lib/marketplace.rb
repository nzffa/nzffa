module Marketplace
  include Radiant::Taggable
  desc 'Tags to load marketplace into the current page'

  nav_links = "<a href='/account/'>Your Groups</a> | 
               <a href='/membership/details/'>Your Account</a> |
               <a href='/account/logout'>Logout</a>"
  tag 'hello_or_login' do |tag|
    current_reader = Reader.current
    if current_reader
      "hello #{current_reader.forename}. #{nav_links}"
    else
      "<a href='/account/login'>Login</a> or <a href='/membership/register/'>Signup</a>"
    end
  end

  tag 'hello_or_blank' do |tag|
    current_reader = Reader.current
    if current_reader
      "hello #{current_reader.forename}. #{nav_links}"
    else
      ''
    end
  end

  tag 'adverts' do |tag|
    %{<div id="adverts"></div>
      <script type="text/javascript">$('#adverts').load('#{adverts_path}')</script>}
  end

  tag 'my_adverts' do |tag|
        %{<div id="adverts"></div>
          <script type="text/javascript">$('#adverts').load('#{my_adverts_adverts_path}')</script>}
  end

  tag 'edit_company_listing' do |tag|
    %{<div id="adverts"></div>
      <script type="text/javascript">$('#adverts').load('#{edit_company_listing_adverts_path}')</script>}
  end

  tag 'new_advert' do |tag|
  %{<div id="adverts"></div>
    <script type="text/javascript">$('#adverts').load('#{new_advert_path}')</script>}
  end

  tag 'register' do |tag|
        %{<div id="adverts"></div>
          <script type="text/javascript">$('#adverts').load('/membership/register')</script>}
  end

  tag 'join-fft-button' do |tag|
    %{<div id="join-fft-button"></div>
      <script type="text/javascript">$('#join-fft-button').load('#{join_fft_button_path}')</script>}
  end
end
