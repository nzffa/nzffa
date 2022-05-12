class XeroOrderSync < ActiveRecord::Base
  belongs_to :xero_sync, :counter_cache => true

  belongs_to :order
  after_create :update_order

  def update_order
    xero_invoice = XeroConnection.client.Invoice.find(xero_invoice_id)
    if xero_invoice.fully_paid_on_date
      # xero_payment exposes limited information; not account paid to, for one
      payment = XeroConnection.client.Payment.find(xero_payment_id)
      # Allowed payment methods in Order model:
      # ['Direct Debit', 'Direct Credit', 'Credit Card', 'Cheque', 'Cash', 'Online', 'NoCharge']
      payment_method = case payment.account.code
      when '1-1000' # ANZ bank account; Direct Debit?
        'Direct Debit'
      when '1-1180'
        'Cheque'
      else
        'Credit Card' # Make all the rest Credit Card for now..
      end
      order.paid!(payment_method, xero_invoice.fully_paid_on_date)
    end
  end
end
