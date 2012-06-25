class AddNewFieldsToAdverts < ActiveRecord::Migration
  def self.up
    add_column :adverts, :timber_for_sale, :text
    add_column :adverts, :supplier_of, :text
    add_column :adverts, :buyer_of, :text
    add_column :adverts, :services, :text
    add_column :adverts, :website, :text
    add_column :adverts, :business_description, :text
    add_column :adverts, :admin_notes, :text
    add_column :adverts, :ffr_contact, :boolean
  end

  def self.down
    remove_column :adverts, :ffr_contact
    remove_column :adverts, :admin_notes
    remove_column :adverts, :business_description
    remove_column :adverts, :website
    remove_column :adverts, :services
    remove_column :adverts, :buyer_of
    remove_column :adverts, :supplier_of
    remove_column :adverts, :timber_for_sale
  end
end
