module ReaderMixin
  def self.included(base)
    base.extend(ClassMethods)
    #base.before_validation do
      #self.nzffa_membership_id ||= next_membership_id
    #end
  end

  module ClassMethods
    def next_membership_id
      last_member = self.find(:first, :conditions => 'nzffa_membership_id is not null', :order => 'nzffa_membership_id desc')
      (last_member.nzffa_membership_id || 0) + 1
    end
  end

  def belongs_to_branch?
    group_ids.each do |group_id|
      return true if NZFFA_BRANCH_GROUP_IDS.include? group_id
    end
    false
  end
end
