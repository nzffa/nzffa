class AppliesSubscriptionGroups
  def self.apply(subscription, reader)
    case subscription.membership_type
    when 'nzffa'
      if subscription.belong_to_fft
        reader.groups << Group.find(NzffaSettings.fft_group_id)
      end
      reader.groups << Group.find(NzffaSettings.tree_grower_nz_group_id)

      subscription.branches.each do |branch|
        #branches are not groups...
        reader.groups << branch.group
      end
    when 'fft_only'
      reader.groups << Group.find(NzffaSettings.fft_group_id)
    when 'tree_grower_only'
      reader.groups << Group.find(NzffaSettings.tree_grower_nz_group_id)
    end
  end
end
