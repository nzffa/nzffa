class XeroOrderSync < ActiveRecord::Base
  belongs_to :xero_sync, :counter_cache => true

  belongs_to :order
  after_create :update_order

  def update_order
    xero_invoice = gateway.get_invoice(xero_invoice_id).invoice
    if xero_invoice.fully_paid_on
      # xero_payment exposes limited information; not account paid to, for one
      payment = gateway.get_payment(xero_payment_id)
      # need to parse response_xml here as xero_gateway does not set @payment_code
      payment_account_code = Nokogiri::XML(payment.response_xml).css("Code").text
      # Allowed payment methods in Order model:
      # ['Direct Debit', 'Direct Credit', 'Credit Card', 'Cheque', 'Cash', 'Online', 'NoCharge']
      payment_method = case payment_account_code
      when '1-1000' # ANZ bank account; Direct Debit?
        'Direct Debit'
      when '1-1180'
        'Cheque'
      else
        'Credit Card' # Make all the rest Credit Card for now..
      end
      order.paid!(payment_method, xero_invoice.fully_paid_on)
    end
  end

  def gateway
    @gateway ||= XeroGateway::PrivateApp.new(XERO_CONSUMER_KEY, XERO_CONSUMER_SECRET, XERO_PEM_PATH)
  end
end
