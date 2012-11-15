class AddPaidOnToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :paid_on, :date
  end

  def self.down
    remove_column :orders, :paid_on
  end
end
