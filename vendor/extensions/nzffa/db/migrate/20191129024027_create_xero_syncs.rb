class CreateXeroSyncs < ActiveRecord::Migration
  def self.up
    create_table :xero_syncs do |t|
      t.datetime :completed_at
      t.integer :xero_order_syncs_count
      t.timestamps
    end
  end

  def self.down
    drop_table :xero_syncs
  end
end
