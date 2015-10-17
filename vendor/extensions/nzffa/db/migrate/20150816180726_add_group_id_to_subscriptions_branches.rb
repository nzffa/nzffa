class AddGroupIdToSubscriptionsBranches < ActiveRecord::Migration
  def self.up
    add_column :subscriptions_branches, :group_id, :integer
    SubscriptionsBranch.reset_column_information
    SubscriptionsBranch.all.each do |branch_subscription|
      branch_subscription.update_attribute :group_id, Branch.find(branch_subscription.branch_id).group_id
    end
    add_index :subscriptions_branches, :group_id
    # remove_column :subscriptions_branches, :branch_id
  end

  def self.down
    remove_index :subscriptions_branches, :group_id
  end
end