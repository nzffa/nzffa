class AddPaymentMethodToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :payment_method, :string
  end

  def self.down
    remove_column :orders, :payment_method
  end
end
