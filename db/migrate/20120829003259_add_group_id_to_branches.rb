class AddGroupIdToBranches < ActiveRecord::Migration
  def self.up
    add_column :branches, :group_id, :integer
  end

  def self.down
    remove_column :branches, :group_id
  end
end
