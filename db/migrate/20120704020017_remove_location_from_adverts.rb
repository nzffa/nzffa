class RemoveLocationFromAdverts < ActiveRecord::Migration
  def self.up
    remove_column :adverts, :location
  end

  def self.down
    add_column :adverts, :location, :string
  end
end
