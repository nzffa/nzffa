class BackOfficeMailer < ActionMailer::Base
  

  def advert_confirmation(advert, sent_at = Time.now)
    subject    "Advert Confirmation Request - #{advert.title[0..25]}"
    recipients ['Derek@Gunn.co.nz']
    from       'noreply@nzffa.org.nz'
    sent_on    sent_at
    
    body       :advert => advert
  end

end
 