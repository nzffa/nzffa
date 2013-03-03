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
              full_membership_group_id
              special_interest_group_levys
              fft_newsletter_group_id
              nzffa_members_newsletter_group_id
              newsletter_editors_group_id
              councillors_group_id
              presidents_group_id
              secretarys_group_id
              treasurers_group_id 
              past_members_group_id ]

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

  @past_members_group_id = 237
  @newsletter_editors_group_id = 214
  @councillors_group_id = 203
  @presidents_group_id = 216
  @secretarys_group_id = 219
  @treasurers_group_id = 220

  @admin_levy = 19

  @forest_size_levys = {'0 - 10'  => 0, 
                        '11 - 40' => 51, 
                        '41+'     => 120}

  @special_interest_group_levys = {
    'Eucalyptus Action Group'  => 15,
    'Cypress Development Group' => 15,
    'Acacia Melanoxylon Interest Group Organisation (AMIGO)' => 15,
    'Indigenous Forest Section' => 30,
    'Sequoia Action Group' => 15
  }

  @full_member_tree_grower_magazine_levy = 50
  @tree_grower_magazine_within_new_zealand = 50
  @tree_grower_magazine_within_australia = 55
  @tree_grower_magazine_everywhere_else = 60

  @full_member_fft_marketplace_levy = 15
  @casual_member_fft_marketplace_levy = 15

  @fft_marketplace_group_id = 229
  @tree_grower_magazine_group_id = 80
  @full_membership_group_id = 232

  @fft_newsletter_group_id = 230
  @nzffa_members_newsletter_group_id = 211
end
