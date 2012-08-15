class AddDurationToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :duration, :string
  end

  def self.down
    remove_column :subscriptions, :duration
  end
end
