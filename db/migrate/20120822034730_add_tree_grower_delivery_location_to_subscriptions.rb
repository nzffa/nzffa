class AddTreeGrowerDeliveryLocationToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :tree_grower_delivery_location, :string
  end

  def self.down
    remove_column :subscriptions, :tree_grower_delivery_location
  end
end
