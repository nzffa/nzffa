class FixCounterCacheColumn < ActiveRecord::Migration
  def self.up
    change_column :forums, :topics_count, :integer, :null => false, :default => 0
  end

  def self.down
  end
end
