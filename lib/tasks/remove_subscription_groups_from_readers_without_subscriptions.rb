subscription_group_ids = [11, 12, 13, 15, 16, 17, 18, 19, 20, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39, 80, 201, 209, 211, 217, 221, 225, 229, 230, 232]

@readers = Reader.all.select do |r| 
  if !r.active_subscription and r.group_ids.any?{|id| subscription_group_ids.include?(id) }
    r.group_ids -= subscription_group_ids
    r.group_ids += [237] # add past members group
    r.save false
    puts "removed #{r.id} #{r.email} #{r.name}"
  end
  puts "Past members group size: #{Group.find(237).readers.size}"
end
