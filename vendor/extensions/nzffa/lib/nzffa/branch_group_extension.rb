module Nzffa::BranchGroupExtension
  
  def self.included(klass)
    klass.class_eval do
      def self.branches
        self.branches_holder.children
      end
      
      def self.branches_holder
        find(Radiant::Config['branches_root_group_id'])
      end
    end
  end
  
  def is_branch_group?
    branches_group = Group.find(Radiant::Config['branches_root_group_id'])
    return self.ancestors.concat([self]).include? branches_group
  end
end