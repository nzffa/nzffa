class BackOfficeMailer < ActionMailer::Base
  

  def advert_confirmation(advert, sent_at = Time.now)
    subject    "Advert Confirmation Request - #{advert.title[0..25]}"
    recipients ['Derek@Gunn.co.nz']
    from       'noreply@nzffa.org.nz'
    sent_on    sent_at
    
    body       :advert => advert
  end
  
  def new_member_paid_registration(member)
    subject    "A new member has just paid his registration online - NZFFA ID #{member.nzffa_membership_id}"
    recipients ['admin@nzffa.org.nz', 'benny@gorilla-webdesign.be']
    from       'noreply@nzffa.org.nz'
    sent_on    Time.now
    
    body       :member => member
  end

end
 