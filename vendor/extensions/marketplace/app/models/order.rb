class Order < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :reader
  validates_presence_of :amount, :reader, :subscription

  def paid!
    update_attribute(:paid_on, Date.today)
  end
end
