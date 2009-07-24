class CreatePresidentials < ActiveRecord::Migration
  def self.up
    create_table :presidentials do |t|
      t.string :title
      t.string :name
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :presidentials
  end
end
