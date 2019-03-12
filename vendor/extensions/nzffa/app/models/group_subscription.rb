class GroupSubscription < ActiveRecord::Base
  belongs_to :group
  belongs_to :subscription
end
