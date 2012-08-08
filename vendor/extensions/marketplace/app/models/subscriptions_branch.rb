class SubscriptionsBranch < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :branch
end
