require 'httparty'
class PxPayParty
  include HTTParty
  #format :xml

  def self.setup(settings)
    @@settings = settings
  end

  def self.payment_url_for(params)
    reply_xml = post('https://sec.paymentexpress.com/pxpay/pxaccess.aspx', 
                     :body => generate_request(params).to_xml(:root => 'GenerateRequest'))
    reply = Hash.from_xml(reply_xml)
    reply['Request']['URI']
  end

  def self.generate_request(params)
    {'PxPayUserId' => @@settings[:px_pay_user_id],
     'PxPayKey' => @@settings[:px_pay_key],
     'AmountInput' => params[:amount],
     'CurrencyInput' => (params[:currency] || @@settings[:currency]),
     'MerchantReference' => params[:merchant_reference],
     'TxnType' => 'Purchase',
     'UrlFail' => @@settings[:fail_url],
     'UrlSuccess' => @@settings[:success_url] }
  end
end
