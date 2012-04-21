class RemoveStyleFromPaperclipPath < ActiveRecord::Migration
  def self.up
    Radiant.config["paperclip.path"] = ":rails_root/public/system/:attachment/:id/:basename:no_original_style.:extension"
    Radiant.config["paperclip.url"] = "/system/:attachment/:id/:basename:no_original_style.:extension"
  end

  def self.down
  end
end
