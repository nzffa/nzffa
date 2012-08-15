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

  describe 'quote' do
    it 'returns a price given a subscription in params' do
      Subscription.stub(:new).and_return(stub(:subscription, :yearly_fee => 10))
      get :quote, :subscription => {}
      response.body.should == '$10'
    end
  end
end
