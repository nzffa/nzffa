class AddHaOfPlantedTreesToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :ha_of_planted_trees, :string
  end

  def self.down
    remove_column :subscriptions, :ha_of_planted_trees
  end
end
