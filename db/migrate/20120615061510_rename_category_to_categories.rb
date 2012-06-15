class RenameCategoryToCategories < ActiveRecord::Migration
  def self.up
    rename_column :adverts, :category, :categories
  end

  def self.down
    rename_column :adverts, :categories, :category
  end
end
