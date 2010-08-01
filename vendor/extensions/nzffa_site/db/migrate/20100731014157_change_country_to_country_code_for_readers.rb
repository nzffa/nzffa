class ChangeCountryToCountryCodeForReaders < ActiveRecord::Migration
  def self.up
    rename_column :readers, :country, :country_code
    rename_column :readers, :billing_country, :billing_country_code
  end

  def self.down
    rename_column :readers, :billing_country_code, :billing_country
    rename_column :readers, :country_code, :country
  end
end