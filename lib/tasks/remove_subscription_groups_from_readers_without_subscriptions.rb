subscription_group_ids = [229, 80, 232, 230, 211]
@readers = Reader.all.select do |r| 
  if !r.active_subscription and r.group_ids.any?{|id| subscription_group_ids.include?(id) }
    r.groups -= subscription_group_ids
    puts "removed #{r.id} #{r.email} #{r.name}"
  end
end
