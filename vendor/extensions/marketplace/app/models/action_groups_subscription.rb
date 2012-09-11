class ActionGroupsSubscription < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :action_group
end
