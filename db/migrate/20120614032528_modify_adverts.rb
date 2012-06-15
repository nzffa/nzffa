class ModifyAdverts < ActiveRecord::Migration

  def self.up
    add_column :adverts, :expires_on, :date
    add_column :adverts, :reader_id, :integer
    change_column :adverts, :price, :decimal, :precision => 10, :scale => 2
    add_column :adverts, :timber_species, :string
    add_column :adverts, :is_company_listing, :boolean, :allow_null => false, :default => false
    rename_column :adverts, :ad_type, :category
    rename_column :adverts, :status, :is_published
    change_column :adverts, :is_published, :boolean, :allow_null => false, :default => false
    remove_column :adverts, :person_id
  end

  def self.down
    add_column :adverts, :person_id
    rename_column :adverts, :is_published, :status
    rename_column :adverts, :category, :ad_type
    remove_column :adverts, :is_company_listing
    remove_column :adverts, :timber_species
    change_column :adverts, :price, :integer
    remove_column :adverts, :reader_id
    remove_column :adverts, :expires_on
  end
end
