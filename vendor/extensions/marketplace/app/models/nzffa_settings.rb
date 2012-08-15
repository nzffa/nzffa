class NzffaSettings
  class << self
    attr_accessor :admin_levy
    attr_accessor :forest_size_levys
    attr_accessor :tree_grower_for_members
    attr_accessor :fft_marketplace_membership
  end
  @admin_levy = 34
  @forest_size_levys = {'0 - 10'  => 0, 
                        '11 - 40' => 51, 
                        '41+'     => 120}
  @tree_grower_for_members = 50
  @fft_marketplace_membership = 15
end
