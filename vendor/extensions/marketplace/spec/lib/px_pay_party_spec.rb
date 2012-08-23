require 'httparty'
require 'active_support'
require 'lib/px_pay_party'

describe PxPayParty do
  describe 'requesting a payment url' do
    before :each do
      PxPayParty.setup({:success_url => 'http://good.com',
                        :fail_url => 'http://bad.com',
                        :currency => 'NZD',
                        :px_pay_user_id => 'NZFFA_dev',
                        :px_pay_key => '0edb744f3d87e729ae22dc66dcdd7db8bc52ac5dbcb6ca613ef99d457481ad35'})
    end
    it 'returns a url to send the client to so they can pay' do
      url = PxPayParty.payment_url_for(:amount => '10.00',
                                       :merchant_reference => 'Order:5')

      url.should =~ /^https:\/\/sec\.paymentexpress\.com\/pxpay\/pxpay\.aspx\?/
    end
  end
end
