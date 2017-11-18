class NotifySubscriber < ActionMailer::Base
  def subscription_expiring_soon(subscription)
    recipients  subscription.reader.email
    from        "NZFFA Renewals <noreply@nzffa.org.nz>"
    subject     "Your NZFFA subscription will expire in #{subscription.days_to_expire} days"
    content_type "text/html"
    reply_to    'noreply@nzffa.org.nz'
    sent_on     Time.now
    body        :subscription => subscription
  end

  # def subscription_expired_email(subscription)
  #   @subscription = subscription
  #   recipients subscription.reader.email
  #   from "NZFFA Marketplace <noreply@nzffa.org.nz>"
  #   subject "Your NZFFA subscription has expired"
  #   content_type  "text/html"
  #   reply_to 'noreply@nzffa.org.nz'
  #   sent_on Time.now
  #   body
  # end
end
