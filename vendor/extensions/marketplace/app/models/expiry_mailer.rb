class ExpiryMailer < ActionMailer::Base
  def warning_email(advert)
    #recipients advert.reader.email
    @advert = advert
    recipients 'rguthrie@gmail.com'
    from "NZFFA Marketplace <noreply@nzffa.org.nz>"
    subject 'Your listing will expire in 7 days'
    sent_on Time.now
    body
  end
end
