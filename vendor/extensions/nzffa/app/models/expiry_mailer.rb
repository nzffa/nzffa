class ExpiryMailer < ActionMailer::Base
  def warning_email(advert)
    #recipients advert.reader.email
    @advert = advert
    recipients advert.reader.email
    from "NZFFA Marketplace <noreply@nzffa.org.nz>"
    subject 'Your listing will expire in 7 days'
    content_type  "text/html"
    reply_to 'noreply@nzffa.org.nz'
    sent_on Time.now
    body
  end
end
