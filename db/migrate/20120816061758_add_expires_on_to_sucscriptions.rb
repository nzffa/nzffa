class AddExpiresOnToSucscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :expires_on, :date
  end

  def self.down
    remove_column :subscriptions, :expires_on
  end
end
