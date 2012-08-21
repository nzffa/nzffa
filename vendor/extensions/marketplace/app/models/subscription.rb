class Subscription < ActiveRecord::Base
  FFT_BRANCH_NAME = 'Farm Forestry Timbers'

  has_many :subscriptions_branches
  has_many :branches, :through => :subscriptions_branches
  belongs_to :main_branch, :class_name => 'Branch'
  validates_presence_of :expires_on

  validates_inclusion_of :ha_of_planted_trees, 
    :in => NzffaSettings.forest_size_levys.keys

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

  def quote_yearly_fee
    (cost_of(:admin_levy) + 
     cost_of(:ha_of_planted_trees) +
     cost_of(:branches) +
     cost_of(:fft) +
     cost_of(:tree_grower_magazine)).to_i
  end

  def quote_total_fee
    case duration
    when 'full_year' 
      quote_yearly_fee
    when 'remainder_of_year_plus_next_year'
      quote_yearly_fee + (quote_yearly_fee * self.class.quarters_remaining)
    else
      'no duration'
    end
  end

  def self.quarters_remaining
    day = Date.today.strftime('%m%d').to_i
    
    if (day >= 101) and (day < 215)
      1
    elsif (day >= 215) and (day < 515)
      0.75
    elsif (day >= 515) and (day < 815)
      0.5
    elsif (day >= 815) and (day < 1115)
      0.25
    elsif (day >= 1115) and (day < 1232)
      0
    else
      raise 'today\'s date is not possible'
    end
  end

  def cost_of(attr)
    begin
      case attr
      when :admin_levy
        34
      when :ha_of_planted_trees
        NzffaSettings.forest_size_levys[ha_of_planted_trees].to_i || 0
      when :branches
        (branches.map(&:annual_levy).sum || 0).to_i
      when :fft
        belong_to_fft ? 15 : 0
      when :tree_grower_magazine
        50
      end
    rescue Exception
      raise "yep exception thrown in cost of #{attr}"
    end
  end
end
