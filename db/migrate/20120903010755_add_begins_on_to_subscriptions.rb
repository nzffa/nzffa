class AddBeginsOnToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :begins_on, :date
  end

  def self.down
    remove_column :subscriptions, :begins_on
  end
end
