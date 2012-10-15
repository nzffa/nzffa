class Subscription < ActiveRecord::Base
  FFT_BRANCH_NAME = 'Farm Forestry Timbers'

  has_one :order, :dependent => :destroy
  belongs_to :reader
  has_many :subscriptions_branches, :dependent => :destroy
  has_many :branches, :through => :subscriptions_branches
  belongs_to :main_branch, :class_name => 'Branch'
  has_many :action_groups_subscriptions, :dependent => :destroy
  has_many :action_groups, :through => :action_groups_subscriptions

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

  
  def self.current_subscription_for(reader)
    find(:all, :conditions => {:reader_id => reader.id}, :order => 'id desc').each do |sub|
      next if sub.cancelled?
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
    if cancelled_on or !paid?
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
    self.receive_tree_grower_magazine ||= true
    self.ha_of_planted_trees ||= '0 - 10'
  end
  
  def before_save
    if membership_type == 'full'
      self.receive_tree_grower_magazine = true
    end
  end

  def associated_branch_names
    names = branches.map(&:name)
    names -= [main_branch.name] if main_branch.present?
    names
  end

  def associated_branch_names=(branch_names)
    if main_branch.present?
      branch_names -= [main_branch.name]
    end
    self.branches += Branch.find(:all, :conditions => {:name => branch_names})
  end

  def main_branch_name
    if main_branch.present?
      self.main_branch.name
    else
      nil
    end
  end

  def main_branch_name=(name)
    self.main_branch = Branch.find_by_name(name)
    self.branches << self.main_branch
  end

  def price_when_sold
    if order and order.paid?
      order.amount
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
