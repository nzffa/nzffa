class AddNeedsXeroUpdateFlagToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :needs_xero_update, :boolean, default: false
  end

  def self.down
    remove_column :orders, :needs_xero_update
  end
end
