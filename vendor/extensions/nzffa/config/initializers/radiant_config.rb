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
    
    nzffa.define 'full_member_tgm_levy', :value => 50
    
    nzffa.define 'casual_member_marketplace_levy', :value => 15
    nzffa.define 'full_member_marketplace_levy', :value => 15
  end
end