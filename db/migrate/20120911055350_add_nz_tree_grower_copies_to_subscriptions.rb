class AddNzTreeGrowerCopiesToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :nz_tree_grower_copies, :integer, :default => 1
  end

  def self.down
    remove_column :subscriptions, :nz_tree_grower_copies
  end
end
