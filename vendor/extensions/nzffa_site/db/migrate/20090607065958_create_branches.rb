class CreateBranches < ActiveRecord::Migration
  def self.up
    create_table :branches do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :cell
      t.string :fax
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :branches
  end
end
