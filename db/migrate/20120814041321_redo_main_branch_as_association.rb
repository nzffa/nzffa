class RedoMainBranchAsAssociation < ActiveRecord::Migration
  def self.up
    if Subscription.columns.map(&:name).include?('main_branch')
      remove_column :subscriptions, :main_branch
    end
    unless Subscription.columns.map(&:name).include?('main_branch_id')
      add_column :subscriptions, :main_branch_id, :integer
    end
  end

  def self.down
    remove_column :subscriptions, :main_branch_id
    add_column :subscriptions, :main_branch
  end
end
