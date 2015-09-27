class NzffaSettings
  NAMES = %w[ admin_levy
              forest_size_levys
              full_member_tree_grower_magazine_levy
              full_member_fft_marketplace_levy
              casual_member_fft_marketplace_levy
              tree_grower_magazine_within_new_zealand
              tree_grower_magazine_within_australia
              tree_grower_magazine_everywhere_else
              fft_marketplace_group_id
              tree_grower_magazine_group_id
              tree_grower_magazine_australia_group_id
              tree_grower_magazine_everywhere_else_group_id
              full_membership_group_id
              special_interest_group_levys
              fft_newsletter_group_id
              nzffa_members_newsletter_group_id
              newsletter_editors_group_id
              councillors_group_id
              presidents_group_id
              secretarys_group_id
              treasurers_group_id 
              past_members_group_id
              small_scale_forest_grower_newsletter_group_id
              forest_grower_levy_payer_newsletter_group_id ]

  class << self
    NAMES.each do |name|
      attr_accessor name
    end
  end

  def self.remove_defaults
    NAMES.each do |name|
      self.send("#{name}=", nil)
    end
  end

  @admin_levy = Radiant::Config["nzffa.admin_levy"]
  
  @forest_size_levys = {}
  ['0 - 10', '11 - 40', '41+'].each do |key|
    @forest_size_levys[key] = Radiant::Config["nzffa.forest_size_#{key.gsub(' ','')}_levy"].to_i
  end

  @full_member_tree_grower_magazine_levy = Radiant::Config["nzffa.full_member_tgm_levy"].to_i

  @full_member_fft_marketplace_levy = Radiant::Config["nzffa.full_member_marketplace_levy"].to_i
  @casual_member_fft_marketplace_levy = Radiant::Config["nzffa.casual_member_marketplace_levy"].to_i
  
  @fft_marketplace_group_id = Radiant::Config["nzffa.fft_marketplace_group_id"].to_i
  @fft_newsletter_group_id = Radiant::Config["nzffa.fft_newsletter_group_id"].to_i
  
  @full_membership_group_id = Radiant::Config["nzffa.full_membership_group_id"].to_i
  @small_scale_forest_grower_newsletter_group_id = Radiant::Config["nzffa.small_scale_fg_newsletter_group_id"].to_i
  @forest_grower_levy_payer_newsletter_group_id = Radiant::Config["nzffa.fg_levy_payer_newsletter_group_id"].to_i
  
  @nzffa_members_newsletter_group_id = Radiant::Config["nzffa.members_newsletter_group_id"].to_i
end
