class Subscription < ActiveRecord::Base
  FFT_BRANCH_NAME = 'Farm Forestry Timbers'

  has_one :order
  belongs_to :reader
  has_many :subscriptions_branches
  has_many :branches, :through => :subscriptions_branches
  belongs_to :main_branch, :class_name => 'Branch'
  validates_inclusion_of :membership_type, :in => ['full', 'casual']
  validates_inclusion_of :duration, :in => ['full_year', 'remainder_of_year_plus_next_year']
  validates_inclusion_of :tree_grower_delivery_location, :in => ['new_zealand', 'australia', 'everywhere_else']
  validates_presence_of :expires_on, :begins_on
  validates_presence_of :reader

  validates_inclusion_of :ha_of_planted_trees, 
    :in => NzffaSettings.forest_size_levys.keys, :if => 'membership_type == "full"'

  def after_initialize
    self.duration ||= 'full_year'
    #self.begins_on ||= Date.new(Date.today.year, 1,1)
    #self.expires_on ||= quote_expires_on
  end

  def before_validation
    self.begins_on = quote_begins_on
    self.expires_on = quote_expires_on
  end

  def quote_expires_on
    case duration
    when 'full_year'
      Date.new(Date.today.year, 12, 31)
    when 'remainder_of_year_plus_next_year'
      Date.new(Date.today.year + 1, 12, 31)
    else
      # default to end of year
      Date.new(Date.today.year, 12, 31)
    end
  end

  def quote_begins_on
    case duration
    when 'remainder_of_year_plus_next_year'
      Date.today
    else
      Date.new(Date.today.year, 1, 1)
    end
  end

  def associated_branch_names
    names = branches.map(&:name)
    names -= main_branch.name if main_branch.present?
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


end
