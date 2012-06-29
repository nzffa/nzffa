class AddCompanyNameToAdverts < ActiveRecord::Migration
  def self.up
    add_column :adverts, :company_name, :string
  end

  def self.down
    remove_column :adverts, :company_name
  end
end
