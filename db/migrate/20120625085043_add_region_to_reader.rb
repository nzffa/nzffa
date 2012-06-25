class AddRegionToReader < ActiveRecord::Migration
  def self.up
    add_column :readers, :region, :string
  end

  def self.down
    remove_column :readers, :region
  end
end
