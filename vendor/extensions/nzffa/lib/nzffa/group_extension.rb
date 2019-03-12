module Nzffa::GroupExtension
  
  def self.included(klass)
    klass.class_eval do
      
      named_scope :branches, :conditions => ['ancestry = ?', Radiant::Config['nzffa.branches_group_id'] ]
      
      def self.branches_holder
        find(Radiant::Config['nzffa.branches_group_id'])
      end
      
      named_scope :action_groups, :conditions => ['ancestry = ?', Radiant::Config['nzffa.action_groups_group_id']]
      
      def self.action_groups_holder
        find(Radiant::Config['nzffa.action_groups_group_id'])
      end
      
      %w(past_members past_casual_members newsletter_editors councillors presidents secretarys treasurers
      fft_marketplace tg_magazine_nz tgm_australia tgm_everywhere_else full_membership fft_newsletter small_scale_fg_newsletter fg_levy_payer_newsletter).each do |gname|
        eval "def self.#{gname}_group; find(Radiant::Config['nzffa.#{gname}_group_id']); end"
      end
      
      def self.fft_group
        find(NzffaSettings.fft_marketplace_group_id)
      end
    end
  end
  
  def has_annual_levy?
    is_branch_group? || is_action_group? || is_fft_group?
  end
  
  def is_branch_group?
    ancestors.include? Group.branches_holder
  end
  
  def is_action_group?
    ancestors.include? Group.action_groups_holder
  end
  
  def is_fft_group?
    id == Group.fft_group.id
  end
end
