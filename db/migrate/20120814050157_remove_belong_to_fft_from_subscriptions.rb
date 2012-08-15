class RemoveBelongToFftFromSubscriptions < ActiveRecord::Migration
  def self.up
    remove_column :subscriptions, :belong_to_fft
  end

  def self.down
    add_column :subscriptions, :belong_to_fft, :boolean
  end
end
