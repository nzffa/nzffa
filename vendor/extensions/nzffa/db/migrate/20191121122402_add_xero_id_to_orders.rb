class AddXeroIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :xero_id, :string
  end

  def self.down
    remove_column :orders, :xero_id
  end
end
