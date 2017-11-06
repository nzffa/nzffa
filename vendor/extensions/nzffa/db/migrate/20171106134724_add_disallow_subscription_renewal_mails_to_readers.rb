class AddDisallowSubscriptionRenewalMailsToReaders < ActiveRecord::Migration
  def self.up
    add_column :readers, :disallow_renewal_mails, :boolean, :default => false
  end

  def self.down
    remove_column :readers, :disallow_renewal_mails
  end
end
