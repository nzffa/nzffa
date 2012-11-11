class AddTopicsCountToForum < ActiveRecord::Migration
  def self.up
    add_column :forums, :topics_count, :integer
  end

  def self.down
    remove_column :forums, :topics_count
  end
end
