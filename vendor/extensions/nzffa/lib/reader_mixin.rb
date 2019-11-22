module ReaderMixin

  module ClassMethods
    def with_membership(args={})
      active = args[:must_be_active] != false
      type = args[:type] || 'full'
      raise ArgumentError.new("Reader.with_membership called with type other than 'full' or 'casual'") unless ['full', 'casual'].include?(type)

      if active
        now = lambda{Date.today}
        find(:all, :include => [:subscriptions => :order], :conditions => ["subscriptions.membership_type = ? and subscriptions.begins_on <= ? AND subscriptions.expires_on >= ? AND subscriptions.cancelled_on IS NULL AND orders.paid_on > '2001-01-01'", type, now.call, now.call])
      else
        find(:all, :include => :subscriptions, :conditions => ["subscriptions.membership_type = ?", type])
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
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
      :receive_small_scale_forest_grower_newsletter => NzffaSettings.small_scale_forest_grower_newsletter_group_id,

      :is_newsletter_editor => NzffaSettings.newsletter_editors_group_id,
      :is_councillor => NzffaSettings.councillors_group_id,
      :is_secretary => NzffaSettings.secretarys_group_id,
      :is_president => NzffaSettings.presidents_group_id,
      :is_treasurer => NzffaSettings.treasurers_group_id,
      :is_resigned => NzffaSettings.resigned_members_group_id }

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
    if forename.present? and surname.present?
      "#{forename} #{surname}"
    else
      nil
    end
  end

  def has_real_email_address?
    !(email =~ /(\d+)@nzffa.org.nz/)
  end

  def postal_address
    [post_line1,
     post_line2,
     post_city,
     post_province,
     post_country,
     postcode]
  end

  def postal_address_array
    [post_line1,
     post_line2,
     "#{post_city} #{postcode}",
     post_province,
     post_country].select{|e| e.present?}
  end

  def postal_address_string
    postal_address_array.join("\n")
  end

  def active_subscription
    Subscription.active_subscription_for(self)
  end

  def has_active_subscription?
    !active_subscription.nil?
  end

  def subscription_for_next_year
    Subscription.next_year_subscription_for(self)
  end

  def has_subscription_for_next_year?
    !subscription_for_next_year.nil?
  end

  def main_branch
    active_subscription.main_branch if active_subscription.present?
  end

  def main_branch_name
    main_branch.name if main_branch
  end

  def main_branch_id
    # Appears to not be in use..
    # main_branch.id if main_branch
  end

  def main_branch_group_id
    main_branch.id if main_branch
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
    (group_ids & [NzffaSettings.tg_magazine_new_zealand_group_id, NzffaSettings.tgm_australia_group_id, NzffaSettings.tgm_everywhere_else_group_id]).join(' ')
  end

  def associated_branch_group_ids_string
    if active_subscription
      group_ids = []
      if active_subscription.belongs_to_fft
        group_ids << NzffaSettings.fft_marketplace_group_id
      end
      group_ids += active_subscription.associated_branches.map(&:id)
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
      ids = []
      if active_subscription.belongs_to_fft
        ids << NzffaSettings.fft_marketplace_group_id
      end
      ids += Group.action_groups.find_all_by_id(group_ids).map(&:id)
      ids.join(' ')
    end
  end

  def current_branches_from_groups
    Group.branches.find_all_by_id(group_ids)
  end

  def action_group_names
    if sub = Subscription.active_subscription_for(self)
      sub.groups.action_groups.map(&:name)
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
      return true if Group.branches.map(&:id).include? group_id
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
    (group_ids & [204, 237, 240, 205, 211, 226, 214, 203, 216, 235, 219, 220]).join(' ')
  end

  def is_complimentary_tree_grower?
    special_cases_include? 102
  end

  def is_options_only?
    special_cases_include? 900
  end

  def is_branch_life_member?
    special_cases_include? 101
  end

  def is_paid_branch_life_member?
    special_cases_include? 111
  end

  def is_life_member?
    special_cases_include? 107
  end

  def is_direct_debit?
    special_cases_include? 204
  end

  def is_olsens?
    special_cases_include? 110
  end

  def pays_base_levys?
    is_life_member? or is_branch_life_member?
  end

  def get_contact_id
    unless xero_id.nil? or xero_id.blank?
      xero_id
    else
      @gateway ||= XeroGateway::PrivateApp.new(XERO_CONSUMER_KEY, XERO_CONSUMER_SECRET, XERO_PEM_PATH)
      all_xero_contacts = Nokogiri::XML(@gateway.get_contacts.response_xml).css("Contacts Contact")
      matching_contact = all_xero_contacts.select{|xc| xc.css("Name").text == self.name }.first
      if matching_contact
        self.update_attribute :xero_id, matching_contact.css("ContactID").text
      else
        contact = @gateway.build_contact
        contact.name = self.name
        contact.email = self.email
        contact.phone.number = self.phone
        contact.address.line_1 = self.post_line1
        contact.address.line_2 = self.post_line2
        contact.address.city = self.post_city
        contact.address.region = self.post_province
        contact.address.country = self.post_country
        contact.address.post_code = self.postcode
        response = contact.save
        if response.status == 'OK'
          self.update_attribute :xero_id, Nokogiri::XML(response.response_xml).css("ContactID").text
        end
      end
    end
  end

  private

  def special_cases_include?(case_number)
    split_special_cases.include? case_number.to_s
  end

  def split_special_cases
    if special_cases.present?
      special_cases.split(' ')
    else
      []
    end
  end

end
