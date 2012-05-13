class CreateReaderGroupPayments < ActiveRecord::Migration
  def self.up
    create_table :reader_group_payments, :force => true do |t|
      t.integer :reader_id
      t.integer :group_id
      t.float :amount
      t.date :payment_date
      t.timestamps
    end
  end

  def self.down
    drop_table :reader_group_payments
  end
end