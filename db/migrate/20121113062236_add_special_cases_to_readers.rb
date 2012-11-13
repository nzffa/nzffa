class AddSpecialCasesToReaders < ActiveRecord::Migration
  def self.up
    add_column :readers, :special_cases, :string
  end

  def self.down
    remove_column :readers, :special_cases
  end
end
