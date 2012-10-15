module ReaderMixin
  def self.included(base)
    #base.extend(ClassMethods)
    base.send(:has_many, :adverts)
    base.send(:validates_presence_of, :forename)
    base.send(:validates_presence_of, :surname)
    base.send(:validates_presence_of, :email)
    base.before_create :assign_nzffa_membership_id
  end


  def assign_nzffa_membership_id
    unless nzffa_membership_id.present?
      last_member = self.class.find(:first, :conditions => 'nzffa_membership_id is not null', :order => 'nzffa_membership_id desc')

      if last_member
        next_id = last_member.nzffa_membership_id + 1
      else
        next_id = 1
      end

      self.nzffa_membership_id = next_id
    end
  end

  def belongs_to_branch?
    group_ids.each do |group_id|
      return true if NZFFA_BRANCH_GROUP_IDS.include? group_id
    end
    false
  end

  def full_nzffa_member?
    group_ids.include? NzffaSettings.full_membership_group_id
  end
end
