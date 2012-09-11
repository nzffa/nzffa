class CreateActionGroupsSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :action_groups_subscriptions do |t|
      t.integer :action_group_id
      t.integer :subscription_id
    end
    add_index :action_groups_subscriptions, :action_group_id
    add_index :action_groups_subscriptions, :subscription_id
  end

  def self.down
    remove_index :action_groups_subscriptions, :column => :subscription_id
    remove_index :action_groups_subscriptions, :column => :action_group_id
    drop_table :action_groups_subscriptions
  end
end
