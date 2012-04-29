class RenameReadersFirstAndLastName < ActiveRecord::Migration
  def self.up
    rename_column :readers, :first_name, :forename
    rename_column :readers, :last_name, :surname
  end

  def self.down
    rename_column :readers, :forename, :first_name
    rename_column :readers, :surname, :last_name
  end
end
