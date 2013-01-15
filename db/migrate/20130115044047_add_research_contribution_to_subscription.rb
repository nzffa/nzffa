class AddResearchContributionToSubscription < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :contribute_to_research_fund, :boolean, :default => false, :null => false
    add_column :subscriptions, :research_fund_contribution_amount, :float
    add_column :subscriptions, :research_fund_contribution_is_donation, :boolean, :default => false
  end

  def self.down
    remove_column :subscriptions, :research_fund_contribution_is_donation
    remove_column :subscriptions, :research_fund_contribution_amount
    remove_column :subscriptions, :contribute_to_research_fund
  end
end
