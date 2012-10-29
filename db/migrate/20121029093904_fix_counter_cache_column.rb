class FixCounterCacheColumn < ActiveRecord::Migration
  def self.up
    change_column :forums, :topics_count, :integer, :null => false, :default => 0
    Forum.each do |f|
      Forum.reset_counters(f.id, :topics)
    end
  end

  def self.down
  end
end
