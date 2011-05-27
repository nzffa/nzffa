class AddYearForToReaderGroupPayments < ActiveRecord::Migration
  def self.up
    add_column :reader_group_payments, :year_for, :integer
  end

  def self.down
    remove_column :reader_group_payments, :year_for
  end
end
