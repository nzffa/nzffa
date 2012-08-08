class Subscription < ActiveRecord::Base
  has_many :subscriptions_branches
  has_many :branches, :through => :subscriptions_branches
end
