class SubscriptionsBranch < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :branch, :class_name => 'Group', :foreign_key => 'group_id'
end
