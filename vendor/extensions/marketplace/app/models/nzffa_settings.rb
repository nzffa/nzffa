class NzffaSettings
  class << self
    attr_accessor :admin_levy
    attr_accessor :forest_size_levys
    attr_accessor :tree_grower_for_members
    attr_accessor :fft_marketplace_membership
    attr_accessor :fft_marketplace_membership_only
    attr_accessor :tree_grower_magazine_within_new_zealand
    attr_accessor :tree_grower_magazine_within_australia
    attr_accessor :tree_grower_magazine_everywhere_else
  end
  @admin_levy = 34
  @forest_size_levys = {'0 - 10'  => 0, 
                        '11 - 40' => 51, 
                        '41+'     => 120}
  @tree_grower_for_members = 50
  @fft_marketplace_membership = 15
  @fft_marketplace_membership_only = 50
  @tree_grower_magazine_within_new_zealand = 40
  @tree_grower_magazine_within_australia = 50
  @tree_grower_magazine_everywhere_else = 60
end
