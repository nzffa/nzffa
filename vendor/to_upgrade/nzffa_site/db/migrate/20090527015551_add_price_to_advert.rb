class AddPriceToAdvert < ActiveRecord::Migration
  def self.up
    add_column :adverts, :price, :integer
  end

  def self.down
    remove_column :adverts, :price
  end
end
