class ActionGroupsSubscription < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :action_group, :class_name => 'Group', :foreign_key => 'group_id'
end
