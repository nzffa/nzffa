class FixCounterCacheColumn < ActiveRecord::Migration
  def self.up
    change_column :forums, :topics_count, :integer, :null => false, :default => 0
    ids = Set.new
    Topic.all.each {|c| ids << c.forum_id}
    ids.each do |forum_id|
      next if forum_id.nil?
      Forum.reset_counters(forum_id, :comments)
    end
  end

  def self.down
  end
end
