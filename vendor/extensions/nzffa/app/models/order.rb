class Order < ActiveRecord::Base
  # Leaving 'Cheque' in there for now, so as not to invalidate previous orders
  PAYMENT_METHODS = ['Direct Debit', 'Direct Credit', 'Credit Card', 'Cheque', 'Cash', 'Online', 'NoCharge']
  belongs_to :subscription, dependent: :destroy
  belongs_to :old_subscription, class_name: 'Subscription', readonly: false
  has_many :order_lines, dependent: :destroy
  has_many :refundable_order_lines, conditions: {is_refundable: true}, class_name: 'OrderLine'
  has_many :charge_order_lines, conditions: 'amount >= 0', class_name: 'OrderLine'
  has_many :refund_order_lines, conditions: 'amount < 0', class_name: 'OrderLine'

  accepts_nested_attributes_for :order_lines, reject_if: :all_blank
  validates_presence_of :amount, :subscription
  validates_numericality_of :amount
  validates_inclusion_of :payment_method, in: PAYMENT_METHODS, allow_blank: true
  validates_presence_of :payment_method, if: :paid_on

  default_scope :order => "created_at DESC"

  named_scope :synced_to_xero, conditions: "xero_id IS NOT NULL AND needs_xero_update IS FALSE"
  named_scope :not_synced_to_xero, conditions: "xero_id IS NULL OR needs_xero_update IS TRUE"
  named_scope :with_not_zero_amount, conditions: "amount > 0 OR amount < 0"

  delegate :reader, to: :subscription
  delegate :nzffa_member_id, to: :reader

  after_save :check_if_paid
  after_create :create_xero_invoice

  def admin_and_forest_size_levy
    admin_levy + forest_size_levy
  end

  def admin_levy
    line_amount(:admin_levy)
  end

  def forest_size_levy
    line_amount('forest_size_levy')
  end

  def tree_grower_levy
    line_amount('nz_tree_grower_magazine_levy')
  end

  def fft_marketplace_levy
    line_amount('fft_marketplace_levy')
  end

  def branches_levy
    order_lines.select{|l| l.kind == 'branch_levy'}.map(&:amount).sum
  end

  def action_groups_levy
    order_lines.select{|l| l.kind == 'action_group_levy'}.map(&:amount).sum
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

  def add_extra_products_from_params_hash(phash)
    phash.to_hash.each do |idstring, actual_amount|
      # "products"=>{"1_amount"=>"2", "2_amount"=>"0", "3_amount"=>"1", ...}
      if actual_amount.to_i > 0
        product = Product.find(idstring.to_i)
        self.add_charge(kind: 'extra_product',
                         particular: "#{actual_amount}x #{product.name} (#{idstring})",
                         amount: (product.price.to_i * actual_amount.to_i))
      end
    end
    self.amount = self.calculate_amount
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

  def advance_payment?
    subscription.expires_on > Date.today.end_of_year
  end

  def add_order_lines_to_invoice(invoice)
    order_lines.each do |line|
      case line.kind
      when "admin_levy" # 'national' levy; what goes to NZFFA head office
        if branch = Group.find_by_name(line.particular)
          account_code = branch.account_codes.split(",").last # admin levies always go to the '4 accounts..'
          li = invoice.add_line_item(
            description: "Admin levy",
            account_code: account_code,
            unit_amount: line.amount
          )
          li.add_tracking(name: 'Branch', option: line.particular)
        elsif line.particular == 'fft_marketplace'
          account_code = Group.fft_group.account_codes.split(",").last
          invoice.add_line_item(
            description: "FFT Admin levy",
            account_code: account_code,
            unit_amount: line.amount
          )
        end
      when "branch_levy"
        branch = Group.find_by_name(line.particular)
        if advance_payment?
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
        if advance_payment?
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
        if advance_payment?
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
      when "extra_product"
        # self.add_charge(kind: 'extra_product',
        #                  particular: "#{actual_amount}x #{product.name} (#{idstring})",
        #                  amount: (product.price.to_i * actual_amount.to_i))
        r=Regexp.new /(\d)x.*\((\d)\)/
        product_amount, product_id = line.particular.match(r)[1,2]
        product = Product.find(product_id)
        invoice.add_line_item(
          description: product.name,
          account_code: product.xero_account,
          unit_amount: product.price,
          quantity: product_amount
        )
      when "extra"
        if line.particular == 'Credit Card Surcharge'
          invoice.add_line_item(
            description: line.particular,
            account_code: "6-1180",
            unit_amount: line.amount
          )
        else
          invoice.add_line_item(
            description: "Extra #{line.particular}",
            account_code: "4-3580",
            unit_amount: line.amount
          )
        end
      end
    end
  end

  def create_xero_invoice
    begin
      XeroConnection.verify
      creation_date = advance_payment? ? (Date.today.end_of_year + 1.day) : created_at
      contact = XeroConnection.client.Contact.find(reader.get_contact_id)
      invoice = XeroConnection.client.Invoice.build(
        type: "ACCREC",
        status: "AUTHORISED",
        date: creation_date,
        due_date: (creation_date + 1.month),
        invoice_number: id,
        reference: "Member ID #{reader.nzffa_membership_id}",
        line_amount_types: "Inclusive",
        contact: contact
      )
      add_order_lines_to_invoice(invoice)
      if invoice.line_items.any?
        invoice.save
        self.update_attribute :xero_id, invoice.id
      end
    rescue Xeroizer::XeroizerError
      # fail silently, invoice can always be created on Xero later..
    end
  end

  def update_xero_invoice
    begin
      XeroConnection.verify
      creation_date = advance_payment? ? (Date.today.end_of_year + 1.day) : updated_at
      invoice = XeroConnection.client.Invoice.find(xero_id)
      invoice.due_date = (creation_date + 1.month)
      invoice.line_items.clear
      add_order_lines_to_invoice(invoice)
      if invoice.line_items.any?
        invoice.save
      end
    rescue Xeroizer::XeroizerError
      # mark order as needing an update in xero, else we'd miss these on next sync
      self.update_attribute :needs_xero_update, true
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
