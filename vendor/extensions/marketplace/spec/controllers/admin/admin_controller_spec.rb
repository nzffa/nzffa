require 'spec_helper'

describe AdminController do

  it 'requires an admin user' do
    get :index
    puts 'here i am!'
    response.should be_redirect
  end
end
