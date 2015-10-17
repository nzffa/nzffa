class MembershipMailer < ActionMailer::Base
  def registration_email(reader_params)
    @reader_params = reader_params
    recipients reader_params[:email]
    from "NZFFA <noreply@nzffa.org.nz>"
    subject 'Thanks for registering with the NZFFA'
    content_type  "text/html"
    reply_to 'noreply@nzffa.org.nz'
    sent_on Time.now
  end
end
