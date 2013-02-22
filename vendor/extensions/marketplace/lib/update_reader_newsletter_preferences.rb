module UpdateReaderNewsletterPreferences
  protected
  def update_newsletter_preference
    fft_newsletter_group = Group.find(NzffaSettings.fft_newsletter_group_id)
    nzffa_members_newsletter_group = Group.find(NzffaSettings.nzffa_members_newsletter_group_id)

    #fft newsletter 
    if params[:receive_fft_newsletter]
      unless @reader.groups.include? fft_newsletter_group
        @reader.groups << fft_newsletter_group
        @newsletter_alert = 'Subscribed to Farm Forestry Timbers Newsletter.'
      end
    else
      if @reader.groups.include? fft_newsletter_group
        @reader.groups.delete(fft_newsletter_group)
        @newsletter_alert = 'Unsubscribed from Farm Forestry Timbers Newsletter.'
      end
    end

    #nzffa members newsletter
    if @reader.full_nzffa_member?
      if params[:receive_nzffa_members_newsletter]
        unless @reader.groups.include? nzffa_members_newsletter_group
          @reader.groups << nzffa_members_newsletter_group
          @newsletter_alert = 'Subscribed to NZFFA Members Newsletter.'
        end
      else
        if @reader.groups.include? nzffa_members_newsletter_group
          @reader.groups.delete(nzffa_members_newsletter_group)
          @newsletter_alert = 'Unsubscribed to NZFFA Members Newsletter.'
        end
      end
    end
  end
end
