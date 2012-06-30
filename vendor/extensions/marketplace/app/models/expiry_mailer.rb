class ExpiryMailer < ActionMailer::Base
  def warning_email(advert)
    recipients advert.reader.email
    from "NZFFA Marketplace <noreply@nzffa.org.nz>"
    subject 'Your listing will expire in 7 days'
    sent_on Time.now
    body({:advert => advert, :reader => advert.reader})
  end
end
