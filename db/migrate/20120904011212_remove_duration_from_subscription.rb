class RemoveDurationFromSubscription < ActiveRecord::Migration
  def self.up
    remove_column :subscriptions, :duration
  end

  def self.down
    add_column :subscriptions, :duration, :string
  end
end
