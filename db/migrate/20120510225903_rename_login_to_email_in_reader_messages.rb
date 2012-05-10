class RenameLoginToEmailInReaderMessages < ActiveRecord::Migration
  class Message < ActiveRecord::Base
  end

  def self.up
    Message.reset_column_information
    Message.all.each do |message|
      changed_body = message.body.gsub(/\<r\:recipient:login/, '<r:recipient:email')
      changed_body = changed_body.gsub(/\<r\:sender:email/, '<r:sender:address')
      message.update_attribute(:body, changed_body)
    end
  end

  def self.down
  end
end
