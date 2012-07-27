class AdjustACoupleMoreReaders < ActiveRecord::Migration
  def self.up
    {
     13 => 48624,
     21 => 48650 
    }.each_pair do |reader_id, membership_id|
      reader = Reader.find(reader_id)
      reader.update_attribute(:nzffa_membership_id, membership_id)
      puts "updated #{reader.name}"
    end
  end

  def self.down
  end
end
