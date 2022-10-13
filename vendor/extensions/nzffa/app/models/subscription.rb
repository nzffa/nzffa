class Subscription < ActiveRecord::Base
  has_one :order, :dependent => :destroy
  belongs_to :reader
  belongs_to :main_branch, :class_name => 'Group'

  has_many :group_subscriptions, :dependent => :destroy, :source => :group
  has_many :groups, :through => :group_subscriptions

  validates_inclusion_of :tree_grower_delivery_location, :in => ['new_zealand', 'australia', 'everywhere_else'], :if => 'receive_tree_grower_magazine?'
  validates_presence_of :ha_of_planted_trees, :if => 'membership_type == "full"'
  validates_presence_of :nz_tree_grower_copies
  validates_presence_of :expires_on, :begins_on
  validates_presence_of :reader
  validates_numericality_of :research_fund_contribution_amount, :greater_than_or_equal_to => 0

  validates_inclusion_of :ha_of_planted_trees,
    :in => NzffaSettings.forest_size_levys.keys, :if => 'membership_type == "full"'

  named_scope :active, lambda {
    {joins: :order,
     conditions: ['begins_on <= ? AND expires_on >= ? AND cancelled_on IS NULL AND orders.paid_on > "2001-01-01"',  Date.today, Date.today, ],
     readonly: false}}

  named_scope :active_for_reader, lambda { |reader|
    {:joins => :order,
     :conditions => ['begins_on <= ? AND expires_on >= ? AND
                      cancelled_on IS NULL AND orders.paid_on > "2001-01-01"
                      AND reader_id = ?',  Date.today, Date.today, reader.id ]}}

  named_scope :active_anytime, {:joins => :order, :conditions => ['cancelled_on IS NULL AND orders.paid_on > "2001-01-01"' ]}
  # named_scope :full_membership, {:conditions => "membership_type = 'full'"}
  # named_scope :casual_membership, {:conditions => "membership_type = 'casual'"}

  named_scope :expiring_before, lambda{|expiry_date|
    {joins: :order,
     conditions: ['begins_on <= ? AND
       expires_on >= ? AND
       expires_on <? AND
       cancelled_on IS NULL AND
       orders.paid_on > "2001-01-01"', Date.today, Date.today, expiry_date]}
    }

  named_scope :expiring_on, lambda {|expiry_date|
    {conditions: {expires_on: expiry_date, cancelled_on: nil}}}

  named_scope :with_readers_having_no_real_email_or_disallowing_renewal_mails, {joins: :reader,
    conditions: ["(readers.email LIKE ?) OR (readers.disallow_renewal_mails = ?)", '%@nzffa.org.nz', true]}

  def self.last_subscription_for(reader)
    find_by_reader_id(reader.id, :order => 'id desc')
  end

  def self.last_paid_subscription_for(reader)
    find_by_reader_id(reader.id,
      :joins => :order,
      :conditions => ['cancelled_on IS NULL AND orders.paid_on > "2001-01-01"'],
      :order => 'id desc')
  end

  def self.current_subscription_for(reader)
    find_by_reader_id(reader.id, :conditions => ['begins_on <= :today
                                and expires_on > :today
                                and cancelled_on is null',
                                {:today => Date.today}],
                               :order => 'id desc')
  end

  def self.last_year_subscription_for(reader)
    first_day = 1.year.ago.at_beginning_of_year
    last_day = 1.year.ago.at_end_of_year
    find_by_reader_id(reader.id, :joins => :order,
               :conditions => ['begins_on >= :first_day
                 and expires_on <= :last_day
                 and cancelled_on is null
                 and orders.paid_on > "2001-01-01"',
                {:first_day => first_day, :last_day => last_day}],
                :order => 'id desc')
  end

  def self.next_year_subscription_for(reader)
    first_day = 1.year.from_now.at_beginning_of_year
    last_day = 1.year.from_now.at_end_of_year
    find_by_reader_id(reader.id,
      :joins => :order,
      :conditions => ['begins_on >= :first_day
        and expires_on >= :last_day
        and cancelled_on is null
        and orders.paid_on > "2001-01-01"', {:first_day => first_day, :last_day => last_day}],
      :order => 'id desc')
  end

  def self.most_recent_subscription_for(reader)
    find_by_reader_id(reader.id, :conditions => 'cancelled_on is null', :order => 'id desc')
  end

  def self.active_subscription_for(reader)
    active.find_by_reader_id(reader.id, :order => 'id desc')
  end

  def self.new_with_same_attributes(old_sub)
    new do |sub|
      [:reader,
       :membership_type,
       :main_branch,
       :begins_on,
       :expires_on,
       :contribute_to_research_fund,
       :research_fund_contribution_amount,
       :research_fund_contribution_is_donation,
       :tree_grower_delivery_location,
       :ha_of_planted_trees,
       :receive_tree_grower_magazine,
       :special_interest_groups,
       :belongs_to_fft,
       :nz_tree_grower_copies].each do |attr|
         sub.send "#{attr}=", old_sub.send(attr)
       end

       sub.groups.concat old_sub.groups
    end
  end

  def renew_for_year(year)
    subscription = Subscription.new_with_same_attributes(self)

    beginning_of_next_year = Date.parse "#{year}-01-01"
    end_of_next_year       = Date.parse "#{year}-12-31"

    subscription.begins_on = beginning_of_next_year
    subscription.expires_on = end_of_next_year
    subscription
  end

  def can_upgrade?
    paid? and (not cancelled?) and active?
  end

  def paid?
    order.present? and order.paid?
  end

  def days_to_expire
    expires_on.yday - Date.today.yday
  end

  def description
    list = []
    list << membership_type

    # if membership_type == 'full'
#       list << "Branches: [#{(branches.map{|b| b.name }).join(', ')}]"
#     end

    list << "Begins: #{begins_on}"
    list << "Expires: #{expires_on}"
    list.join(', ')
  end

  def active?
    if cancelled_on.present? or !paid?
      false
    else
      (begins_on..expires_on).include?(Date.today)
    end
  end

  def cancel!
    update_attribute(:cancelled_on, Date.today)
  end

  def cancelled?
    cancelled_on.present?
  end

  def after_initialize
    self.begins_on ||= Date.today
    self.expires_on ||= Date.new(begins_on.year, 12, 31)
    self.receive_tree_grower_magazine = true if self.receive_tree_grower_magazine.nil? # leave alone if set to false..
    self.tree_grower_delivery_location ||= 'new_zealand'
    self.nz_tree_grower_copies ||= 1
    self.ha_of_planted_trees ||= '0 - 10'
    self.research_fund_contribution_amount ||= 0.0
  end

  def research_fund_contribution_amount
    if contribute_to_research_fund?
      self[:research_fund_contribution_amount]
    else
      0
    end
  end

  def branches
    # Do not use groups.branches here; it will make new_with_same_attributes fail
    groups.select{|g| g.is_branch_group?}
  end

  def branches=(ids)
    self.groups -= Group.branches
    self.groups += Group.branches.find(ids.reject(&:blank?))
  end

  def branch_ids
    branches.map &:id
  end

  def branch_names
    branches.map(&:name)
  end

  def main_branch_name
    main_branch.try(:name) || tgm_group.try(:name)
  end

  def main_branch_id=(id)
    if id.blank?
      self.main_branch = (groups & Subscription.subscribable_groups).first || nil
    else
      self.main_branch = Group.find(id)
    end
  end

  def tgm_group
    return nil unless receive_tree_grower_magazine
    case tree_grower_delivery_location
    when 'new_zealand'
      Group.find(NzffaSettings.tg_magazine_new_zealand_group_id)
    when 'australia'
      Group.find(NzffaSettings.tgm_australia_group_id)
    else
      Group.find(NzffaSettings.tgm_everywhere_else_group_id)
    end
  end

  def action_groups
    # Do not use groups.action_groups here; it will make new_with_same_attributes fail
    groups.select{|g| g.is_action_group?}
  end

  def action_groups=(ids)
    self.groups -= Group.action_groups
    self.groups += Group.action_groups.find(ids.reject(&:blank?))
  end

  def action_group_names
    action_groups.map(&:name)
  end

  def action_group_ids
    action_groups.map(&:id)
  end

  def self.subscribable_groups
    Group.branches + Group.action_groups + Group.tgm_groups + [Group.fft_group]
  end

  def belongs_to_fft
    self.groups.include?(Group.fft_group)
  end

  def belongs_to_fft=(bool)
    if bool.is_a? Integer
      bool = bool > 0
    elsif bool.is_a? String
      bool = bool.to_i > 0
    end
    if bool
      self.groups << Group.fft_group
    else
      self.groups -= [ Group.fft_group ]
    end
  end

  def price_when_sold
    if order and order.paid?
      order.amount
    end
  end

  def price_when_sold_without_research_contribution_or_products
    if order and order.paid?
      order.amount - (research_fund_contribution_amount + order.extra_product_order_lines.map(&:amount).sum + order.cc_charge_amount)
    end
  end

  def length_in_years
    CalculatesSubscriptionLevy.subscription_length(begins_on, expires_on)
  end

  def refund_available
    if price_when_sold == nil
      0
    else
      price_when_sold -
        (price_when_sold *
         CalculatesSubscriptionLevy.fraction_used(begins_on, expires_on))
    end
  end

end
