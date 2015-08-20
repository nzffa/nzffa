class AddGroupIdToActionGroupsSubscriptions < ActiveRecord::Migration
  def self.up
    ActionGroup.all.each {|ag| group = Group.find(ag.group_id); group.update_attribute(:annual_levy, ag.annual_levy)}

    add_column :action_groups_subscriptions, :group_id, :integer
    ActionGroupsSubscription.reset_column_information
    ActionGroupsSubscription.all.each do |subscription|
      subscription.update_attribute :group_id, ActionGroup.find(subscription.action_group_id).group_id
    end
    add_index :action_groups_subscriptions, :group_id
    # remove_column :subscriptions_branches, :branch_id
  end

  def self.down
    remove_index :action_groups_subscriptions, :group_id
  end
end
