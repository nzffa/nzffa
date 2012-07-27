class AddNzffaMembershipIdsToExistingReaders < ActiveRecord::Migration
  class Reader < ActiveRecord::Base
  end
  def self.up
    {
     60 => 250,
     71 => 47843,
     43 => 43035,
     48 => 47034,
     29 => 4174,
     14 => 1158,
     188 => 47371
    }.each_pair do |reader_id, membership_id|
      reader = Reader.find(reader_id)
      reader.update_attribute(:nzffa_membership_id, membership_id)
      puts "updated #{reader.name}"
    end

  end

  def self.down
  end
end
