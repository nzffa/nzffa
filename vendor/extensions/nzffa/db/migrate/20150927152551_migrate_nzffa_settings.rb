class MigrateNzffaSettings < ActiveRecord::Migration
  def self.up
    branches_group = Group.find_or_create_by_name('Branches')
    Branch.all.each{|b| b.group.update_attribute(:parent_id, branches_group.id) }
    Radiant::Config["nzffa.branches_group_id"] = branches_group.id
    action_groups_group = Group.find_or_create_by_name('Action Groups')
    ActionGroup.all.each{|b| b.group.update_attribute(:parent_id, action_groups_group.id) }
    Radiant::Config["nzffa.action_groups_group_id"] = action_groups_group.id
    arr = {
      "past_members" => 237,
      "newsletter_editors" => 214,
      "councillors" => 203,
      "presidents" => 216,
      "secretarys" => 219,
      "treasurers" => 220,
      
      "fft_marketplace" => 229,
      "fft_newsletter" => 230,
      "nzffa_members_newsletter" => 211,
      
      "tg_magazine_nz" => 80,
      "tgm_australia" => 81,
      "tgm_everywhere_else" => 82,
      
      "full_membership" => 232,
      "small_scale_fg_newsletter" => 255,
      "fg_levy_payer_newsletter" => 250,
    }
    arr.each {|key, group_id| Radiant::Config["nzffa.#{key}_group_id"] = group_id}

    Group.tg_magazine_nz_group.update_attribute(:annual_levy, 50)
    Group.tgm_australia_group.update_attribute(:annual_levy, 55)
    Group.tgm_everywhere_else_group.update_attribute(:annual_levy, 60)
    
    Radiant::Config['nzffa.admin_levy'] = 19
    
    Radiant::Config['nzffa.forest_size_0-10_levy'] = 0
    Radiant::Config['nzffa.forest_size_11-40_levy'] = 51
    Radiant::Config['nzffa.forest_size_41+_levy'] = 120
    
    Radiant::Config['nzffa.full_member_tgm_levy'] = 50
    
    Radiant::Config['nzffa.casual_member_marketplace_levy'] = 15
    Radiant::Config['nzffa.full_member_marketplace_levy'] = 15
  end

  def self.down
  end
end
