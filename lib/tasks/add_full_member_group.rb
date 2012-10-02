branch_ids = '11 12 13 15 16 17 18 19 20 22 23 24 25 26 27 28 29 30 31 32 33 35 36 37 38 39'.split(' ').map(&:to_i)
full_member_group = Group.find(232)

Reader.all.each do |reader|
  if reader.group_ids.any?{|id| branch_ids.include? id}
    p "adding #{reader.name} to full members"
    reader.groups << full_member_group
  end
end


