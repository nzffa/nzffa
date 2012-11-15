class AddSpecialInterestGroupsToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :special_interest_groups, :text
  end

  def self.down
    remove_column :subscriptions, :special_interest_groups
  end
end
