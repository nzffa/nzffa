require 'lib/px_pay_party'

describe PxPayParty do
  describe 'requesting a payment url' do
    describe 'happy path' do
      it 'returns a url' do
        url = PxPayer.payment_url_for(:amount => 10,
                                :currency => 'NZD',
                                :merchant_reference => 'Order:5')

        url.should == 'http://giveusyourmoney.com/sucker.aspx'

        PaymentWrapper.request_payment_url(:amount => 10.00, :currency => 'NZD', :merchant_reference => 'Order:5')
      end
      it 'does an HTTP POST with the xml'


    end
    describe 'sad path' do
      it 'raises an error if something went wrong'
    end
  end
end
