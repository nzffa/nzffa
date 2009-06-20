class CreatePeople < ActiveRecord::Migration
  def self.up
    add_column :persons, :first_name, :string
    add_column :persons, :last_name, :string
    add_column :persons, :phone, :string
  end
  
  def self.down
    remove_column :persons, :phone
    remove_column :persons, :last_name
    remove_column :persons, :first_name
  end
end
