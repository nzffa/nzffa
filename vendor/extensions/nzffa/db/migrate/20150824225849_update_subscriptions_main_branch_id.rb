class UpdateSubscriptionsMainBranchId < ActiveRecord::Migration
  def self.up
    Subscription.all.each do |sub|
      if sub.main_branch_id && branch = Branch.find(sub.main_branch_id)
        sub.update_attribute :main_branch_id, branch.group_id
      end
    end
  end

  def self.down
  end
end
