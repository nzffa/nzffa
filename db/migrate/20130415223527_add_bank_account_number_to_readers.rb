class AddBankAccountNumberToReaders < ActiveRecord::Migration
  def self.up
    add_column :readers, :bank_account_number, :string
  end

  def self.down
    remove_column :readers, :bank_account_number
  end
end
