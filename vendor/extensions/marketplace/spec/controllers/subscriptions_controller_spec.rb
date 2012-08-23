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
      JSON.parse(response.body).should == {"total_fee"=>"$10.00", "expires_on"=>"20 August 2012"}
    end
  end

  describe 'create' do
    describe 'if subscription params are valid' do
      let(:valid_subscription_params) {
        {:membership_type => 'fft_only',
         :duration => 'full_year'}
      }
      it 'saves the subscription' do
        post :create, :subscription => valid_subscription_params
        assigns(:subscription).should_not be_new_record
      end

      it 'creates an order for the subscription' do
        expect {
          post :create, :subscription => valid_subscription_params
        }.to change(Order, :count).by(1)
      end

      it 'redirects to the make_payment action for the order' do
        post :create, :subscription => valid_subscription_params
        assigns(:order)
        response.should redirect_to make_payment_order_path(assigns(:order))
      end

    end
    describe 'if subscription params are invalid' do
      it 're renders the appropriate form'
    end
  end
end
