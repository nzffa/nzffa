class XeroSync < ActiveRecord::Base
  has_many :xero_order_syncs
  default_scope :order => 'created_at DESC'
  after_create :sync_orders

  named_scope :completed, :conditions => "completed_at IS NOT NULL"

  def sync_orders
    XeroConnection.verify
    last_sync = XeroSync.completed.first.try(:created_at) || (1.week.ago) # to bootstrap..

    XeroConnection.client.Payment.all(:modified_since => last_sync).each do |payment|
      xid = payment.invoice_id
      next unless order = Order.find_by_xero_id(xid)
      Rails.logger.warn("Synchronizing Xero invoice #{xid} to order #{order.id}")
      xero_order_syncs.create(:order => order, :xero_payment_id => payment.id, :xero_invoice_id => xid)
      sleep(2.seconds) # < throws TypeError in Ruby 1.8 :/
    end
    update_attribute :completed_at, Time.now
  end

end
