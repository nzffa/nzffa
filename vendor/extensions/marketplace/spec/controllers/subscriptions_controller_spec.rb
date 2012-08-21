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
      Subscription.stub(:new).and_return(stub(:subscription, 
                                              :quote_total_fee => 10,
                                              :quote_expires_on => Date.parse('2012-08-20')))
      get :quote, :subscription => {}
      JSON.parse(response.body).should == {"total_fee"=>"$10", "expires_on"=>"20 August 2012"}
    end
  end
end
