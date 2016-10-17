class BackOfficeMailer < ActionMailer::Base
  
  def advert_confirmation(advert, sent_at = Time.now)
    subject    "Advert Confirmation Request - #{advert.title[0..25]}"
    recipients ['Derek@Gunn.co.nz']
    from       'admin@nzffa.org.nz'
    sent_on    sent_at
    
    body       :advert => advert
  end
  
  def new_member_paid_registration(member)
    subject    "A new member has just paid his registration online - NZFFA ID #{member.nzffa_membership_id}"
    recipients ['admin@nzffa.org.nz', 'benny@gorilla-webdesign.be']
    from       'admin@nzffa.org.nz'
    sent_on    Time.now
    
    body       :member => member
  end

  def donation_receipt_to_member(order)
    subject    "Thank you for your research fund contribution! Here is your donation receipt."
    recipients order.subscription.reader.email
    # cc         ['admin@nzffa.org.nz']
    from       'admin@nzffa.org.nz'
    sent_on    Time.now
    content_type "text/html"
    
    body       :order => order,
               :reader => order.subscription.reader
  end
end
 