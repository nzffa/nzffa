class AddXeroIdToReaders < ActiveRecord::Migration
  def self.up
    add_column :readers, :xero_id, :string
  end

  def self.down
    remove_column :readers, :xero_id
  end
end
