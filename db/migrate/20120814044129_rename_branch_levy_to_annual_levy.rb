class RenameBranchLevyToAnnualLevy < ActiveRecord::Migration
  def self.up
    rename_column :branches, :levy, :annual_levy
  end

  def self.down
    rename_column :branches, :annual_levy, :levy
  end
end
