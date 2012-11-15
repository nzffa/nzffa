class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :membership_type
      t.integer :reader_id
      t.timestamps
    end
    add_index :subscriptions, :reader_id
  end

  def self.down
    drop_table :subscriptions
    remove_index :subscriptions, :reader_id
  end
end
