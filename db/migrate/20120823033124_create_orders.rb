class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.decimal :amount, :precision => 10, :scale => 2
    end
  end

  def self.down
  end
end
