class RemoveCompanyName < ActiveRecord::Migration
  def self.up
    remove_column :adverts, :company_name
  end

  def self.down
    add_column :adverts, :company_name, :string
  end
end
