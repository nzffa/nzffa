module Nzffa::MessageSubscriptionTags
  include Radiant::Taggable
  include ReaderHelper
  
  class TagError < StandardError; end

  desc %{
    <pre><code><r:recipient:subscription_receipt_url /></code></pre>
  }
  tag "recipient:subscription_receipt_url" do |tag|
    print_subscriptions_url(:reader_id => tag.locals.recipient.id, :token => tag.locals.recipient.perishable_token, :host => @mailer_vars[:@host])
  end
  
  desc %{
    <pre><code><r:recipient:subscription_receipt_link>your subscription receipt</r:recipient:subscription_receipt_link></code></pre>
  }
  tag "recipient:subscription_receipt_link" do |tag|
    options = tag.attr.dup
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    attributes = " #{attributes}" unless attributes.empty?
    text = tag.double? ? tag.expand : "your subscription receipt"
    %{<a href="#{tag.render('recipient:subscription_receipt_url')}"#{attributes}>#{text}</a>}
  end
    
  desc %{
    <pre><code><r:recipient:subscription_print_renewal_url /></code></pre>
  }
  tag "recipient:subscription_print_renewal_url" do |tag|
    print_renewal_subscriptions_url(:reader_id => tag.locals.recipient.id, :token => tag.locals.recipient.perishable_token, :host => @mailer_vars[:@host])
  end
  
  desc %{
    <pre><code><r:recipient:subscription_print_renewal_link>print your renewal form</r:recipient:subscription_print_renewal_link></code></pre>
  }
  tag "recipient:subscription_print_renewal_link" do |tag|
    options = tag.attr.dup
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    attributes = " #{attributes}" unless attributes.empty?
    text = tag.double? ? tag.expand : "print your renewal form"
    %{<a href="#{tag.render('recipient:subscription_print_renewal_url')}"#{attributes}>#{text}</a>}
  end
    
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
