class Order < ActiveRecord::Base
  PAYMENT_METHODS = ['Direct Debit', 'Direct Credit', 'Credit Card', 'Cheque', 'Cash', 'Online', 'NoCharge']
  belongs_to :subscription, :dependent => :destroy
  belongs_to :old_subscription, :class_name => 'Subscription'
  has_many :order_lines, :dependent => :destroy
  has_many :refundable_order_lines, :conditions => {:is_refundable => true}, :class_name => 'OrderLine'
  has_many :charge_order_lines, :conditions => 'amount >= 0', :class_name => 'OrderLine'
  has_many :refund_order_lines, :conditions => 'amount < 0', :class_name => 'OrderLine'

  accepts_nested_attributes_for :order_lines, :reject_if => :all_blank
  validates_presence_of :amount, :subscription
  validates_numericality_of :amount
  validates_inclusion_of :payment_method, :in => PAYMENT_METHODS, :allow_blank => true
  validates_presence_of :payment_method, :if => :paid_on

  delegate :reader, :to => :subscription
  delegate :nzffa_member_id, :to => :reader

  after_save :check_if_paid

  def combined_full_member_levy
    # assume full member
    admin_levy_line = order_lines.select{|l| l.kind == 'admin_levy'}.first
    forest_size_levy_line = order_lines.select{|l| l.kind == 'forest_size_levy'}.first
    tree_grower_levy_line = order_lines.select{|l| l.kind == 'nz_tree_grower_magazine_levy'}.first

    total = admin_levy_line.amount +
            forest_size_levy_line.amount +
            tree_grower_levy_line.amount +
            main_branch_levy
  end

  def associated_branches_levy
    total = order_lines.select{|l| l.kind == 'branch_levy'}.map(&:amount).sum
    total - main_branch_levy
  end

  def main_branch_levy
    admin_levy_line = order_lines.select{|l| l.kind == 'admin_levy'}.first
    main_branch_name = admin_levy_line.particular
    main_branch_levy_line = order_lines.select do |l|
      l.kind == 'branch_levy' && l.particular == main_branch_name
    end.first
    main_branch_levy_line.amount
  end

  def action_groups_levy
    order_lines.select{|l| l.kind == 'action_group_levy'}.map(&:amount).sum
  end

  def casual_nz_tree_grower_levy
    order_lines.select{|l| l.kind == 'casual_member_nz_tree_grower_magazine_levy'}.map(&:amount).sum
  end

  def before_destroy
    unless is_deletable?
      errors.add_to_base('You cannot delete an order that has been paid online')
    end
  end

  def is_deletable?
    not (paid? and payment_method == 'Online')
  end

  def before_validation
    self.amount = calculate_amount
    unless paid?
      if self.amount == 0
        self.paid_on = DateTime.now
        self.payment_method = 'NoCharge'
      end
    end
  end

  def calculate_amount
    amount = order_lines.map(&:amount).sum
    if amount < 0
      0
    else
      amount
    end
  end

  def add_charge(params)
    order_lines.build(params)
  end

  def add_refund(params)
    params[:amount] = -(params[:amount])
    order_lines.build(params)
  end

  def remove_cancelling_order_lines!
    charge_order_lines.each do |charge_line|
      refund_order_lines.each do |refund_line|
        if ( charge_line.kind == refund_line.kind &&
             charge_line.particular == refund_line.particular &&
             charge_line.amount == (0 - refund_line.amount))
           # refund is the same as charge
           order_lines.delete(charge_line)
           order_lines.delete(refund_line)
        end
      end
    end
  end

  def order_id
    id
  end

  def nzffa_member_id
    if reader
      reader.nzffa_membership_id 
    else
      nil
    end
  end

  def paid!(method)
    self.payment_method = method
    unless payment_method.present?
      raise 'Payment method required'
    end
    if old_subscription.present?
      old_subscription.cancel!
    end
    update_attribute(:paid_on, Date.today)
  end

  def paid?
    paid_on.present?
  end

  def check_if_paid
    if paid_on_changed? and paid_on_was.nil? and paid_on.present?
      if old_subscription.present?
        old_subscription.cancel!
      end
    end
  end
end
