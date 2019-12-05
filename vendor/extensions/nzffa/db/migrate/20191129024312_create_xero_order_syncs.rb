class CreateXeroOrderSyncs < ActiveRecord::Migration
  def self.up
    create_table :xero_order_syncs do |t|
      t.integer :xero_sync_id
      t.integer :order_id
      t.string :xero_invoice_id
      t.string :xero_payment_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :xero_order_syncs
  end
end
