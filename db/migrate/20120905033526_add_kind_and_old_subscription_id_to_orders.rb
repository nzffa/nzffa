class AddKindAndOldSubscriptionIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :kind, :string
    add_column :orders, :old_subscription_id, :integer
  end

  def self.down
    remove_column :orders, :old_subscription_id
    remove_column :orders, :kind
  end
end
