class AddAccountCodesToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :account_codes, :string
  end

  def self.down
    remove_column :groups, :account_codes
  end
end
