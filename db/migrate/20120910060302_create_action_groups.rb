class CreateActionGroups < ActiveRecord::Migration
  def self.up
    create_table :action_groups do |t|
      t.string :name
      t.integer :group_id
      t.decimal :annual_levy, :precision => 8, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :action_groups
  end
end
