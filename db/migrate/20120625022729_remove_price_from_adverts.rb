class RemovePriceFromAdverts < ActiveRecord::Migration
  def self.up
    remove_column :adverts, :price
  end

  def self.down
  end
end
