class AddYearForToReaderGroupPayments < ActiveRecord::Migration
  def self.up
    add_column :reader_group_payment, :year_for, :integer
  end

  def self.down
    remove_column :reader_group_payment, :year_for
  end
end
