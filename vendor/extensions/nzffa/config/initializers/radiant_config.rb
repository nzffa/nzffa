Radiant.config do |config|
  config.namespace('nzffa') do |nzffa|
    %w(branches action_groups past_members newsletter_editors councillors presidents secretarys treasurers
      fft_marketplace tg_magazine_nz tgm_australia tgm_everywhere_else full_membership fft_newsletter small_scale_fg_newsletter fg_levy_payer_newsletter).each do |name|
      nzffa.define "#{name}_group_id", :select_from => lambda {Group.all.map{|l| [l.name, l.id.to_s]}}, :allow_blank => true
    end
    
    nzffa.define 'admin_levy', :value => 19
    nzffa.define 'forest_size_0-10_levy', :value => 0
    nzffa.define 'forest_size_11-40_levy', :value => 51
    nzffa.define 'forest_size_41+_levy', :value => 120
  end
end


# @past_members_group_id = 237
# @newsletter_editors_group_id = 214
# @councillors_group_id = 203
# @presidents_group_id = 216
# @secretarys_group_id = 219
# @treasurers_group_id = 220
#
# @admin_levy = 19
#
# @forest_size_levys = {'0 - 10'  => 0,
#                       '11 - 40' => 51,
#                       '41+'     => 120}

#  @fft_marketplace_group_id = 229
#  @tree_grower_magazine_group_id = 80
#  @tree_grower_magazine_australia_group_id = 81
#  @tree_grower_magazine_everywhere_else_group_id = 82
#  @full_membership_group_id = 232
#
#  @fft_newsletter_group_id = 230
#  @nzffa_members_newsletter_group_id = 211
#  @small_scale_forest_grower_newsletter_group_id = 255
#  @forest_grower_levy_payer_newsletter_group_id = 250
