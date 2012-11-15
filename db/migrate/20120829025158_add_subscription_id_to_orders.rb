class AddSubscriptionIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :subscription_id, :integer
    add_index :orders, :subscription_id
  end

  def self.down
    remove_column :orders, :subscription_id
    remove_index :orders, :subscription_id
  end
end
