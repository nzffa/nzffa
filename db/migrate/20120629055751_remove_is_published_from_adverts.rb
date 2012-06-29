class RemoveIsPublishedFromAdverts < ActiveRecord::Migration
  def self.up
    remove_column :adverts, :is_published
  end

  def self.down
    add_column :adverts, :is_published, :boolean
  end
end
