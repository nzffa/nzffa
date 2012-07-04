class MoveBillingAddressToPost < ActiveRecord::Migration
  class Reader < ActiveRecord::Base
  end

  class Advert < ActiveRecord::Base
    belongs_to :reader
  end
  def self.up

    rename_column :readers, :address_1, :physical_address
    remove_column :readers, :address_2
    remove_column :readers, :address_3
    remove_column :readers, :address_4
    remove_column :readers, :post_line1
    remove_column :readers, :post_line2
    rename_column :readers, :billing_address_1, :post_line1
    rename_column :readers, :billing_address_2, :post_line2
    remove_column :readers, :billing_address_3
    remove_column :readers, :region
    rename_column :readers, :billing_address_4, :region
    remove_column :readers, :postcode
    rename_column :readers, :billing_postcode, :postcode
    remove_column :readers, :billing_country_code
    add_column :readers, :website, :string

    Advert.all.each do |a|
      if a.website and a.reader and a.reader.website.blank?
        a.reader.update_attribute(:website, a.website)
      end
    end
    remove_column :adverts, :website
  end

  def self.down
  end
end
