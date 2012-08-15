class AddSubscriptionsBranches < ActiveRecord::Migration
  def self.up
    create_table :subscriptions_branches do |t|
      t.integer :subscription_id
      t.integer :branch_id
      t.timestamps
    end
    add_index :subscriptions_branches, :subscription_id
    add_index :subscriptions_branches, :branch_id
  end

  def self.down
    drop_table :subscriptions_branches
  end
end
