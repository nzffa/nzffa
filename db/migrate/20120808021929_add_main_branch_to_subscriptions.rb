class AddMainBranchToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :main_branch, :string
  end

  def self.down
    remove_column :subscriptions, :main_branch
  end
end
