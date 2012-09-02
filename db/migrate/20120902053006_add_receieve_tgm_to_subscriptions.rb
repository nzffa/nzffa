class AddReceieveTgmToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :receive_tree_grower_magazine, :boolean
  end

  def self.down
    remove_column :subscriptions, :receive_tree_grower_magazine
  end
end
