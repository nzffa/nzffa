class AddCreatedAtAndUpdatedAtToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :created_at, :datetime
    add_column :orders, :updated_at, :datetime
  end

  def self.down
    remove_column :orders, :updated_at
    remove_column :orders, :created_at
  end
end
