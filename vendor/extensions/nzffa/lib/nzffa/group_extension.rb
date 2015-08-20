module Nzffa::GroupExtension
  
  def self.included(klass)
    klass.class_eval do
      def self.branches
        self.branches_holder.children
      end
      
      def self.branches_holder
        find(Radiant::Config['branches_group_id'])
      end
      
      def self.action_groups
        self.action_groups_holder.children
      end
      
      def self.action_groups_holder
        find(Radiant::Config['action_groups_group_id'])
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
