class AddAnnualLevyToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :annual_levy, :integer, :default => 0
    Group.reset_column_information
    Branch.all.each {|b| group = Group.find(b.group_id); group.update_attribute(:annual_levy, b.annual_levy)}
  end

  def self.down
    remove_column :groups, :annual_levy
  end
end
