class AddRefundableToOrderLines < ActiveRecord::Migration
  def self.up
    add_column :order_lines, :is_refundable, :boolean, :default => true

    OrderLine.find(:all, :conditions => {:kind => 'research_fund_contribution'}).each do |line|
      line.update_attribute(:is_refundable, false)
    end
  end

  def self.down
    remove_column :order_lines, :is_refundable
  end
end
