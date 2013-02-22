module ReaderMixin
  def self.included(base)
    #base.extend(ClassMethods)
    base.send(:has_many, :adverts)
    base.send(:has_many, :subscriptions)
    base.send(:has_many, :orders, :through => :subscriptions)
    base.send(:validates_presence_of, :forename)
    base.send(:validates_presence_of, :surname)
    base.send(:validates_presence_of, :email)
    base.send(:validates_presence_of, :post_line1)
    base.send(:validates_presence_of, :post_city)
    base.send(:validates_presence_of, :postcode)
    base.send(:before_validation, :assign_nzffa_membership_id)
    base.send(:validates_uniqueness_of, :nzffa_membership_id)
  end

  def name
    if self[:name]
      self[:name]
    elsif forename.present? and surname.present?
      "#{forename} #{surname}"
    else
      nil
    end
  end

  def active_subscription
    Subscription.active_subscription_for(self)
  end

  def main_branch
    active_subscription.main_branch if active_subscription.present?
  end

  def main_branch_name
    main_branch.name if main_branch
  end

  def main_branch_id
    main_branch.id if main_branch
  end

  def main_branch_group_id
    main_branch.group_id if main_branch
  end

  def associated_branch_ids
    active_subscription.associated_branch_ids if active_subscription.present?
  end

  def associated_branch_ids_string
    associated_branch_ids.join(' ') if associated_branch_ids
  end

  def associated_branches
    active_subscription.associated_branches if active_subscription
  end

  def associated_branch_group_ids_string
    active_subscription.associated_branches.map(&:group_id).join(' ') if active_subscription
  end

  def associated_branch_names
    if sub = Subscription.active_subscription_for(self)
      sub.associated_branch_names
    end
  end

  def action_group_group_ids_string
    active_subscription.action_groups.map(&:group_id).join(' ') if active_subscription
  end

  def action_group_names
    if sub = Subscription.active_subscription_for(self)
      sub.action_groups.map(&:name)
    end
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

  def receive_fft_newsletter?
    fft_newsletter_group = Group.find(NzffaSettings.fft_newsletter_group_id)
    self.groups.include? fft_newsletter_group
  end

  def receive_nzffa_members_newsletter?
    nzffa_members_newsletter_group = Group.find(NzffaSettings.nzffa_members_newsletter_group_id)
    self.groups.include? nzffa_members_newsletter_group
  end

end
