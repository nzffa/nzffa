class AddNzffaMembershipIdToReaders < ActiveRecord::Migration
  def self.up
    add_column :readers, :nzffa_membership_id, :integer
  end

  def self.down
    remove_column :readers, :nzffa_membership_id
  end
end
