class AddBelongToFftToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :belong_to_fft, :boolean, :null => false
  end

  def self.down
    remove_column :subscriptions, :belong_to_fft
  end
end
