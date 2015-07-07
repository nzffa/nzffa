module UpdateReaderNewsletterPreferences
  protected
  def update_newsletter_preference
    # Available to everyone
    %w(fft_newsletter small_scale_forest_grower_newsletter forest_grower_levy_payer_newsletter).each do |group_name|
      group = Group.find(NzffaSettings.send("#{group_name}_group_id"))
      
      if params["receive_#{group_name}"]
        unless @reader.groups.include? group
          @reader.groups << group
          @newsletter_alert = "Subscribed to #{group_name.humanize}."
        end
      else
        if @reader.groups.include? group
          @reader.groups.delete(group)
          @newsletter_alert = "Unsubscribed from #{group_name.humanize}."
        end
      end
    end
    
    # Full members only
    %w(nzffa_members_newsletter).each do |group_name|
      # break unless @reader.full_nzffa_member?
      
      group = Group.find(NzffaSettings.send("#{group_name}_group_id"))
      
      if params["receive_#{group_name}"]
        unless @reader.groups.include? group
          @reader.groups << group
          @newsletter_alert = "Subscribed to #{group_name.humanize}."
        end
      else
        if @reader.groups.include? group
          @reader.groups.delete(group)
          @newsletter_alert = "Unsubscribed from #{group_name.humanize}."
        end
      end
    end
    
  end
end
