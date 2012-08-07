require 'spec_helper'

describe SubscriptionsController do
  context 'new' do
    before do
      get :new
    end
    it 'initializes a new subscription' do
      assigns(:subscription).should be_present
    end
  end
end
