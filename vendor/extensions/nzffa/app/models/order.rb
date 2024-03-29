class Order < ActiveRecord::Base
  # Leaving 'Cheque' in there for now, so as not to invalidate previous orders
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

  default_scope :order => "created_at DESC"

  named_scope :synced_to_xero, conditions: "xero_id IS NOT NULL"
  named_scope :not_synced_to_xero, conditions: "xero_id IS NULL"

  delegate :reader, :to => :subscription
  delegate :nzffa_member_id, :to => :reader

  after_save :check_if_paid
  after_create :create_xero_invoice

  def combined_full_member_levy
    # assume full member
    total = admin_levy+
            forest_size_levy+
            full_member_tree_grower_levy+
            main_branch_levy
  end

  def casual_member_fft_and_admin_levy
     casual_member_fft_levy + admin_levy
  end

  def casual_member_fft_levy
    line_amount('fft_marketplace_levy', 'casual_membership')
  end

  def admin_levy
    line_amount(:admin_levy)
  end

  def forest_size_levy
    line_amount('forest_size_levy')
  end

  def full_member_tree_grower_levy
    line_amount('nz_tree_grower_magazine_levy')
  end

  def associated_branches_levy
    total = order_lines.select{|l| l.kind == 'branch_levy'}.map(&:amount).sum
    total - main_branch_levy
  end

  def main_branch_levy
    admin_levy_line = order_lines.select{|l| l.kind == 'admin_levy'}.first
    return 0 unless admin_levy_line
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

  def paid!(method, date = Date.today)
    self.payment_method = method
    unless payment_method.present?
      raise 'Payment method required'
    end
    if old_subscription.present?
      old_subscription.cancel!
    end
    update_attribute(:paid_on, date)

    if needs_donation_receipt?
      # Send donation receipt
      BackOfficeMailer.deliver_donation_receipt_to_member(Order.find(id))
    end
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

  def needs_donation_receipt?
    subscription.contribute_to_research_fund &&
    subscription.research_fund_contribution_is_donation? && subscription.research_fund_contribution_amount.to_i > 0
  end

  def create_xero_invoice
    begin
      XeroConnection.verify
      advance_payment = subscription.expires_on > Date.today.end_of_year
      creation_date = advance_payment ? (Date.today.end_of_year + 1.day) : created_at
      invoice = XeroConnection.client.Invoice.build(
        type: "ACCREC",
        status: "AUTHORISED",
        date: creation_date,
        due_date: (creation_date + 1.month),
        invoice_number: id,
        reference: "Member ID #{reader.nzffa_membership_id}",
        line_amount_types: "Inclusive"
      )
      contact = invoice.build_contact(
        name: reader.name,
        email_address: reader.email
      )
      contact.add_phone(
        number: reader.phone,
        type: "DEFAULT"
      )
      contact.add_address(
        line1: reader.post_line1,
        line2: reader.post_line2,
        city: reader.post_city,
        region: reader.post_province,
        country: reader.post_country,
        postal_code: reader.postcode,
        type: "STREET"
      )

      # split_order_lines = advance_payment && (subscription.begins_on < Date.today.end_of_year)
      order_lines.each do |line|
        case line.kind
        when "admin_levy"
          if branch = Group.find_by_name(line.particular)
            account_code = branch.account_codes.split(",").last # admin levies always go to the '4 accounts..'
            li = invoice.add_line_item(
              description: "Admin levy",
              account_code: account_code,
              unit_amount: line.amount
            )
            li.add_tracking(name: 'Branch', option: line.particular)
          elsif line.particular == 'fft_marketplace' # FFT admin levy for casual membership
            account_code = Group.fft_group.account_codes.split(",").last
            invoice.add_line_item(
              description: "FFT Admin levy",
              account_code: account_code,
              unit_amount: line.amount
            )
          end
        when "branch_levy"
          branch = Group.find_by_name(line.particular)
          if advance_payment
            index = 1
          else
            index = 0
          end
          account_code = branch.account_codes.split(",")[index]
          li = invoice.add_line_item(
            description: "Branch levy - #{branch.name}",
            account_code: account_code,
            unit_amount: line.amount
          )
          li.add_tracking(name: 'Branch', option: line.particular)
        when "action_group_levy"
          action_group = Group.find_by_name(line.particular)
          account_code = action_group.account_codes
          li = invoice.add_line_item(
            description: "Action group levy - #{action_group.name}",
            account_code: account_code,
            unit_amount: line.amount
          )
          li.add_tracking(name: 'Sub Group', option: line.particular)
        when "forest_size_levy"
          if advance_payment
            account_code = "2-3350" # Advance forest size levies all go on one account
          else
            if line.particular == '0 - 10'
              account_code = "4-1400"
            elsif line.particular == '11 - 40'
              account_code = "4-1402"
            elsif line.particular == '41+'
              account_code = "4-1403"
            end
          end
          invoice.add_line_item(
            description: "Area levy #{line.particular}",
            account_code: account_code,
            unit_amount: line.amount
          )
        when "fft_marketplace_levy"
          fft_group = Group.fft_group
          if advance_payment
            index = 1
          else
            index = 0
          end
          account_code = fft_group.account_codes.split(',')[index]
          invoice.add_line_item(
            description: "FFT marketplace levy - #{line.particular.gsub('_',' ')}",
            account_code: account_code,
            unit_amount: line.amount
          )
        when "nz_tree_grower_magazine_levy"
          invoice.add_line_item(
            description: "NZ Tree Grower Magazine - #{line.particular.gsub('_',' ')}",
            account_code: "4-1500",
            unit_amount: line.amount
          )
        when "casual_member_nz_tree_grower_magazine_levy"
          invoice.add_line_item(
            description: "NZ Tree Grower Magazine - #{line.particular.gsub('_',' ')}",
            account_code: "4-3500",
            unit_amount: line.amount
          )
        when "research_fund_contribution"
          invoice.add_line_item(
            description: "Research fund contribution",
            account_code: "4-2030",
            unit_amount: line.amount
          )
        when "extra"
          invoice.add_line_item(
            description: "Extra",
            account_code: "4-3580",
            unit_amount: line.amount
          )
        end
      end

      if invoice.line_items.any?
        invoice.save
        self.update_attribute :xero_id, invoice.id
      end
    rescue XeroizerError
      # fail silently, invoice can always be created on Xero later..
    end
  end

  private
  def line_amount(kind, particular = nil)
    line = order_lines.select do |l|
      if particular.nil?
        l.kind == kind.to_s
      else
        l.kind == kind.to_s && l.particular == particular
      end
    end.first
    line ? line.amount : 0
  end
end
