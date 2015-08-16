class AppliesSubscriptionGroups
  def self.apply(subscription, reader)
    if subscription.active?
      #remove past members group if it exists
      reader.memberships.find_all_by_group_id(NzffaSettings.past_members_group_id).each(&:destroy)
    
      if subscription.belong_to_fft?
        # swap with fft_newsletter if it exists
        reader.memberships.find_all_by_group_id(NzffaSettings.fft_newsletter_group_id).each(&:destroy)
        reader.groups << Group.find(NzffaSettings.fft_marketplace_group_id)
      end

      case subscription.membership_type
      when 'full'
        reader.groups << Group.find(NzffaSettings.full_membership_group_id)
        reader.groups << Group.find(NzffaSettings.tree_grower_magazine_group_id)
        reader.memberships.find_all_by_group_id(NzffaSettings.small_scale_forest_grower_newsletter_group_id).each(&:destroy)

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
  end

  def self.remove(subscription, reader = nil)
    # Is only ever called from rake task, not from controller
    reader = subscription if reader.nil?
    # find old subscription and add to 'swap' groups
    group_ids_to_delete = []
    group_ids_to_delete << NzffaSettings.fft_marketplace_group_id
    group_ids_to_delete << NzffaSettings.full_membership_group_id
    group_ids_to_delete << NzffaSettings.tree_grower_magazine_group_id
    group_ids_to_delete << NzffaSettings.tree_grower_magazine_australia_group_id
    group_ids_to_delete << NzffaSettings.tree_grower_magazine_everywhere_else_group_id
    group_ids_to_delete.concat ActionGroup.all.map(&:group_id)
    group_ids_to_delete.concat Group.branches.map(&:group_id)
    
    group_ids_to_add = []
    if reader.subscriptions.any?
      group_ids_to_add << NzffaSettings.past_members_group_id
    end
    if reader.group_ids.include? NzffaSettings.fft_marketplace_group_id
      group_ids_to_add << NzffaSettings.fft_newsletter_group_id
    end
    
    group_ids_to_delete.each do |group_id|
      reader.memberships.find_all_by_group_id(group_id).each(&:destroy)
    end
    group_ids_to_add.each do |group_id|
      reader.memberships.create(:group_id => group_id)
    end
  end
end