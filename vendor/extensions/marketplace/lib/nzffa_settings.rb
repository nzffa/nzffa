class NzffaSettings
  class << self
    attr_accessor :admin_levy
    attr_accessor :forest_size_levys
    attr_accessor :full_member_tree_grower_magazine_levy
    attr_accessor :full_member_fft_marketplace_levy
    attr_accessor :casual_member_fft_marketplace_levy
    attr_accessor :tree_grower_magazine_within_new_zealand
    attr_accessor :tree_grower_magazine_within_australia
    attr_accessor :tree_grower_magazine_everywhere_else
    attr_accessor :fft_marketplace_group_id
    attr_accessor :tree_grower_magazine_group_id
    attr_accessor :full_membership_group_id
    attr_accessor :special_interest_group_levys
  end
  @admin_levy = 34

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
  @tree_grower_magazine_within_new_zealand = 40
  @tree_grower_magazine_within_australia = 50
  @tree_grower_magazine_everywhere_else = 60

  @full_member_fft_marketplace_levy = 15
  @casual_member_fft_marketplace_levy = 50

  @fft_marketplace_group_id = 229
  @tree_grower_magazine_group_id = 80
  @full_membership_group_id = 232
end
