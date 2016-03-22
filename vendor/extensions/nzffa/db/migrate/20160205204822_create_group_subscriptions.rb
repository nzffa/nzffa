class CreateGroupSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :group_subscriptions do |t|
      t.integer :group_id
      t.integer :subscription_id

      t.timestamps
    end
    add_index :group_subscriptions, :group_id
    add_index :group_subscriptions, :subscription_id
    
    # Copy SubscriptionsBranch as GroupSubscriptions
    SubscriptionsBranch.all.each do |s|
      GroupSubscription.find_or_create_by_group_id_and_subscription_id(s.group_id, s.subscription_id)
    end
    # Add GroupSubscription for action groups
    ActionGroupsSubscription.all.each do |s|
      GroupSubscription.find_or_create_by_group_id_and_subscription_id(s.group_id, s.subscription_id)
    end
    # Add GroupSubscription for fft group if applicable
    Subscription.all.each do |s|
      s.group_subscriptions.find_or_create_by_group_id(Group.fft_group.id) if s.belong_to_fft
    end
    
  end

  def self.down
    drop_table :group_subscriptions
  end
end
