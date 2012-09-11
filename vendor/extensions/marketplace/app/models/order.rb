class Order < ActiveRecord::Base
  PAYMENT_METHODS = ['Direct Debit', 'Cheque', 'Cash', 'Online']
  belongs_to :subscription
  belongs_to :old_subscription, :class_name => 'Subscription'
  belongs_to :reader
  validates_presence_of :amount, :subscription, :reader
  validates_inclusion_of :payment_method, :in => PAYMENT_METHODS, :allow_blank => true

  def paid!
    if old_subscription.present?
      old_subscription.cancel!
    end
    update_attribute(:paid_on, Date.today)
  end

  def paid?
    paid_on.present?
  end

  def self.upgrade_subscription(old_sub, new_sub)
    create(:kind => 'upgrade',
           :old_subscription => old_sub,
           :subscription => new_sub,
           :reader => new_sub.reader,
           :amount => CalculatesSubscriptionLevy.upgrade_price(old_sub, new_sub),
           :paid_on => nil)
  end
end
