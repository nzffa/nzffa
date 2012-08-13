tree_groups = Group.find(:all, :conditions => {:id => [80,81,82]})
count = 0
tree_groups.each do |group|
  group.readers.each do |reader|
    unless reader.belongs_to_branch?
      count += 1
      if reader.group_ids.include? 100 or reader.group_ids.include? 231
        puts "reader_id: #{reader.id} member_id: #{reader.nzffa_membership_id} name: #{reader.name}"
        reader.group_ids -= [100, 231]
      end
    end
  end
end
puts count
