class AddPhoneToReaders < ActiveRecord::Migration
  def self.up
    add_column :readers, :phone, :string
  end

  def self.down
    remove_column :readers, :phone
  end
end
