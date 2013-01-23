class AddDetailsToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :details, :text
  end

  def self.down
    remove_column :orders, :details
  end
end
