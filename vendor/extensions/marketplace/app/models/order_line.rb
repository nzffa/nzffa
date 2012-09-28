class OrderLine < ActiveRecord::Base
  fields = ['nzffa_member_id', 'subscription_id', 'order_id', 'amount', 'paid_on', 'payment_method']
  belongs_to :order
  delegate :nzffa_member_id, :to => :order
  delegate :subscription_id, :to => :order
  delegate :order_id, :to => :order
  delegate :payment_method, :to => :order
  delegate :paid_on, :to => :order

  def order_line_id
    id
  end
end
