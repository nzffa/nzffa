class AddTermToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :term, :string
  end

  def self.down
    remove_column :subscriptions, :term
  end
end
