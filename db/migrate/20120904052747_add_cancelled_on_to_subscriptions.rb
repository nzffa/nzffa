class AddCancelledOnToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :cancelled_on, :date
  end

  def self.down
    remove_column :subscriptions, :cancelled_on
  end
end
