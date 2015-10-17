class ActionGroup < ActiveRecord::Base
  has_many :action_groups_subscriptions
  belongs_to :group
  validates_presence_of :annual_levy, :group
end
