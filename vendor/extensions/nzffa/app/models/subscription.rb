class Subscription < ActiveRecord::Base
  has_one :order, :dependent => :destroy
  belongs_to :reader
  belongs_to :main_branch, :class_name => 'Group'
  
  has_many :group_subscriptions, :dependent => :destroy, :source => :group
  has_many :groups, :through => :group_subscriptions

  validates_inclusion_of :membership_type, :in => ['full', 'casual']
  validates_inclusion_of :tree_grower_delivery_location, :in => ['new_zealand', 'australia', 'everywhere_else'], :if => 'receive_tree_grower_magazine? && membership_type == "casual"'
  validates_presence_of :ha_of_planted_trees, :if => 'membership_type == "full"'
  validates_presence_of :nz_tree_grower_copies
  validates_presence_of :expires_on, :begins_on
  validates_presence_of :reader

  validates_inclusion_of :ha_of_planted_trees,
    :in => NzffaSettings.forest_size_levys.keys, :if => 'membership_type == "full"'

  named_scope :expiring_on, lambda {|expiry_date| 
    {:conditions => {:expires_on => expiry_date, :cancelled_on => nil}}}

  named_scope :active, lambda { 
    {:joins => :order,
     :conditions => ['begins_on <= ? AND expires_on >= ? AND cancelled_on IS NULL AND orders.paid_on > "2001-01-01"',  Date.today, Date.today, ]}}

  named_scope :active_for_reader, lambda { |reader| 
    {:joins => :order,
     :conditions => ['begins_on <= ? AND expires_on >= ? AND 
                      cancelled_on IS NULL AND orders.paid_on > "2001-01-01"
                      AND reader_id = ?',  Date.today, Date.today, reader.id ]}}

  named_scope :active_anytime, {:joins => :order, :conditions => ['cancelled_on IS NULL AND orders.paid_on > "2001-01-01"' ]}

  def self.expiring_before(date)
    self.active.find(:all, :conditions => ['expires_on <?', date])
  end
  
  def self.last_subscription_for(reader)
    find(:first, :conditions => {:reader_id => reader.id}, :order => 'id desc')
  end

  def self.current_subscription_for(reader)
    find(:all, :conditions => ['reader_id = :reader_id 
                                and begins_on <= :today 
                                and expires_on > :today 
                                and cancelled_on is null', 
                                {:reader_id => reader.id, :today => Date.today}],
                               :order => 'id desc').each do |sub|
      return sub
    end
    nil
  end

  def self.last_year_subscription_for(reader)
    first_day = 1.year.ago.at_beginning_of_year
    last_day = 1.year.ago.at_end_of_year
    find(:all, :joins => :order,
               :conditions => ['reader_id = :reader_id and begins_on >= :first_day and expires_on <= :last_day and cancelled_on is null and orders.paid_on > "2001-01-01"',
                                {:reader_id => reader.id, :first_day => first_day, :last_day => last_day}],
                               :order => 'id desc').each do |sub|
      return sub
    end
    nil
  end

  def self.most_recent_subscription_for(reader)
    find(:all, :conditions => ['reader_id = :reader_id and cancelled_on is null', {:reader_id => reader.id}],
                               :order => 'id desc').each do |sub|
      return sub
    end
    nil
  end

  def self.active_subscription_for(reader)
    find(:all, :conditions => {:reader_id => reader.id}, :order => 'id desc').each do |sub|
      return sub if sub.active?
    end
    nil
  end

  def self.new_with_same_attributes(old_sub)
    new do |sub|
      [:reader,
       :membership_type,
       :main_branch,
       :special_interest_groups,
       :begins_on,
       :expires_on,
       :receive_tree_grower_magazine,
       :contribute_to_research_fund,
       :research_fund_contribution_amount,
       :research_fund_contribution_is_donation,
       :tree_grower_delivery_location,
       :ha_of_planted_trees,
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

    if membership_type == 'full'
      list << "Branches: [#{(branches.map{|b| b.name }).join(', ')}]"
    end

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
    self.tree_grower_delivery_location ||= 'new_zealand'
    self.nz_tree_grower_copies ||= 1
    self.ha_of_planted_trees ||= '0 - 10'
    self.research_fund_contribution_amount ||= 0.0
  end
  
  def before_save
    if membership_type == 'full'
      self.receive_tree_grower_magazine = true
    end
  end

  def research_fund_contribution_amount
    if contribute_to_research_fund?
      self[:research_fund_contribution_amount]
    else
      0
    end
  end

  def action_groups
    # Do not use groups.action_groups here; it will make new_with_same_attributes fail
    groups.select{|g| g.is_action_group?}
  end

  def action_group_names
    action_groups.map(&:name)
  end
  
  def action_group_ids
    action_groups.map(&:id)
  end
  
  def action_group_ids=(ids)
    self.groups -= Group.action_groups
    self.groups += Group.action_groups.find(ids)
  end

  def branches
    # Do not use groups.branches here; it will make new_with_same_attributes fail
    groups.select{|g| g.is_branch_group?}
  end

  def associated_branches
    branches - [ main_branch ]
  end

  def associated_branch_ids
    associated_branches.map(&:id)
  end

  def associated_branch_names
    associated_branches.map(&:name)
  end

  def associated_branch_names=(branch_names)
    if main_branch.present?
      branch_names -= [main_branch.name]
    end
    self.groups += Group.branches.find_all_by_name branch_names
  end

  def main_branch_name
    main_branch.try :name
  end

  def main_branch_name=(name)
    self.main_branch = Group.branches.find_by_name(name)
    self.groups << self.main_branch
  end
  
  def belongs_to_fft
    self.groups.include?(Group.fft_group)
  end
  
  def belongs_to_fft=(bool)
    # Since this is no longer a boolean column, we need to convert ourselves
    if bool.to_i > 0
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

  def price_when_sold_without_research_contribution
    if order and order.paid?
      order.amount - research_fund_contribution_amount
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
