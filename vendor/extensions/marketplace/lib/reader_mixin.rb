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

    group_membership_shortcuts = { 
      :receive_fft_newsletter => NzffaSettings.fft_newsletter_group_id,
      :receive_nzffa_members_newsletter => NzffaSettings.nzffa_members_newsletter_group_id,
      :is_newsletter_editor => NzffaSettings.newsletter_editors_group_id,
      :is_councillor => NzffaSettings.councillors_group_id,
      :is_secretary => NzffaSettings.secretarys_group_id,
      :is_president => NzffaSettings.presidents_group_id,
      :is_treasurer => NzffaSettings.treasurers_group_id }

    group_membership_shortcuts.each do |method_name, group_id|
      define_method(method_name) do
        self.group_ids.include? group_id
      end

      alias_method  "#{method_name}?", method_name

      define_method("#{method_name}=") do |raw_value|
        belong_to_group = if raw_value.is_a? String
                            raw_value.to_i == 1
                          else
                            raw_value
                          end

        group = Group.find(group_id)
        if belong_to_group
          self.groups << group
        else
          self.groups.delete(group)
        end
      end
    end
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
  
  def tree_grower_group_ids
    #NZ Tree Grower subscribers 80, 
    #Australian Tree Grower subscribers 81, 
    #Rest of World Tree Grower subscribers 82
    group_ids.select{|id| [80, 81, 82].include? id }
  end

  def associated_branch_group_ids_string
    if active_subscription
      group_ids = []
      if active_subscription.belong_to_fft?
        group_ids << NzffaSettings.fft_marketplace_group_id 
      end
      group_ids += active_subscription.associated_branches.map(&:group_id)
      group_ids.join(' ')
    end
  end

  def associated_branch_names
    if sub = Subscription.active_subscription_for(self)
      sub.associated_branch_names
    end
  end

  def action_group_group_ids_string
    if active_subscription
      group_ids = []
      if active_subscription.belong_to_fft?
        group_ids << NzffaSettings.fft_marketplace_group_id 
      end
      group_ids += active_subscription.action_groups.map(&:group_id)
      group_ids.join(' ')
    end
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

  def identifiers
    #Direct Debit 204 (Note: This is currently under special_cases)
    #Past members 237
    #Postal Mail 240
    #Executive 205
    #National Newsletter 211
    #Neil Barr Foundation Trustee 226
    #Newsletter Editor 214
    #NZFFA Councillor 203
    #President 216
    #Research Committee 235
    #Secretary 219
    #Treasurer 220
    ids = [204, 237, 240, 205, 211, 226, 214, 203, 216, 235, 219, 220]
    group_ids.select{|id| ids.include?(id) }.join(' ')
  end

end
