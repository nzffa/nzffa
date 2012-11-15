class CreateOrderLines < ActiveRecord::Migration
  def self.up
    create_table :order_lines do |t|
      t.integer :order_id
      t.string :kind
      t.string :particular
      t.decimal :amount, :precision => 8, :scale => 2
      t.timestamps
    end

    add_index :order_lines, :order_id
  end

  def self.down
    drop_table :order_lines
  end
end
