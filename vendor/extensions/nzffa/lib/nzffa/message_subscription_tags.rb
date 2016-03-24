module Nzffa::MessageSubscriptionTags
  include Radiant::Taggable
  include ReaderHelper
  
  class TagError < StandardError; end

  desc %{
    <pre><code><r:recipient:subscription_renewal_url /></code></pre>
  }
  tag "recipient:subscription_renewal_url" do |tag|
    renew_subscriptions_url(:reader_id => tag.locals.recipient.id, :token => tag.locals.recipient.perishable_token, :host => @mailer_vars[:@host])
  end
  
  desc %{
    <pre><code><r:recipient:subscription_renewal_link>renew your subscription</r:recipient:subscription_renewal_link></code></pre>
  }
  tag "recipient:subscription_renewal_link" do |tag|
    options = tag.attr.dup
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    attributes = " #{attributes}" unless attributes.empty?
    text = tag.double? ? tag.expand : "renew your subscription"
    %{<a href="#{tag.render('recipient:subscription_renewal_url')}"#{attributes}>#{text}</a>}
  end

end
