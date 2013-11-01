class AppliesSubscriptionGroups
  def self.apply(subscription, reader)

    #remove past members group if it exists
    if reader.group_ids.include? NzffaSettings.past_members_group_id
      reader.group_ids.delete(NzffaSettings.past_members_group_id)
    end

    if subscription.belong_to_fft?
      reader.groups << Group.find(NzffaSettings.fft_marketplace_group_id)
    end

    case subscription.membership_type
    when 'full'
      reader.groups << Group.find(NzffaSettings.full_membership_group_id)
      reader.groups << Group.find(NzffaSettings.tree_grower_magazine_group_id)

      subscription.branches.each do |branch|
        reader.groups << branch.group unless branch.group.nil?
      end

      
      subscription.action_groups.each do |action_group|
        reader.groups << action_group.group unless action_group.group.nil?
      end

    when 'casual'
      if subscription.receive_tree_grower_magazine?
        group_id = case subscription.tree_grower_delivery_location
                   when 'new_zealand'
                     NzffaSettings.tree_grower_magazine_group_id
                   when 'australia'
                     NzffaSettings.tree_grower_magazine_australia_group_id
                   when 'everywhere_else'
                     NzffaSettings.tree_grower_magazine_everywhere_else_group_id
                   end
        reader.groups << Group.find(group_id)
      end
    else
      raise "unrecognised membership type #{subscription.membership_type}"
    end
  end

  def self.remove(subscription, reader = nil)
    reader = subscription if reader.nil?

    group_ids = []
    group_ids << NzffaSettings.fft_marketplace_group_id
    group_ids << NzffaSettings.full_membership_group_id
    group_ids << NzffaSettings.tree_grower_magazine_group_id
    group_ids << NzffaSettings.tree_grower_magazine_australia_group_id
    group_ids << NzffaSettings.tree_grower_magazine_everywhere_else_group_id
    group_ids << ActionGroup.all.map(&:group_id)
    group_ids << Branch.all.map(&:group_id)


    group_ids.each do |group_id|
      if group = Group.find_by_id(group_id)
        if reader.groups.include? group
          reader.groups.delete(group)
        end
      end
    end

    # add them to the past members group
    reader.group_ids << NzffaSettings.past_members_group_id
  end
end
