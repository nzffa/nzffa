class CreateBranches < ActiveRecord::Migration
  def self.up
    create_table :branches do |t|
      t.string :name
      t.decimal :levy, :precision => 8, :scale => 2
    end
  end

  def self.down
    drop_table :branches
  end
end
