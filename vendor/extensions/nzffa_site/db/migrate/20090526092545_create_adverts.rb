class CreateAdverts < ActiveRecord::Migration
  def self.up
    create_table :adverts do |t|
      t.integer :person_id
      t.string :title
      t.string :location
      t.text :body
      t.string :ad_type
      t.boolean :status

      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :adverts
  end
end