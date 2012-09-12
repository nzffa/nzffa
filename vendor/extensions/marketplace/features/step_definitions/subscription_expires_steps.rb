Given /^the reader's subscription is due to expire in (\d+) days$/ do |arg1|
  @subscription = Subscription.create!(:membership_type => 'casual',
                                       :belong_to_fft => true,
                                       :reader => @reader)

  Order.create!(:subscription => @subscription,
                :reader => @reader,
                :amount => CalculatesSubscriptionLevy.levy_for(@subscription),
                :paid_on => Date.today)

  @subscription.update_attribute(:expires_on, 30.days.from_now)
end

Given /^the reader's subscription is due to expire today$/ do
  @subscription = Subscription.create!(:membership_type => 'casual',
                                       :belong_to_fft => true,
                                       :reader => @reader)

  Order.create!(:subscription => @subscription,
                :reader => @reader,
                :amount => CalculatesSubscriptionLevy.levy_for(@subscription),
                :paid_on => Date.today)

  @subscription.update_attribute(:expires_on, Date.today)
  AppliesSubscriptionGroups.apply(@subscription, @reader)
end

When /^we warn all the soon to be expiring subscribers$/ do
  @subscription.update_attribute(:expires_on, 30.days.from_now.to_date)
  @subscriptions = Subscription.expiring_on(30.days.from_now.to_date)
  @subscriptions.each do |subscription|
    NotifySubscriber.deliver_subscription_expiring_soon(subscription)
  end
end

Then /^the reader should be emailed a warning notification$/ do
  last_email = ActionMailer::Base.deliveries.last
  last_email.to.should include @reader.email
    
  last_email.subject.should == "Your NZFFA subscription will expire in 30 days"
  last_email.body.should =~ /Your subscription will expire in 30 days/
  last_email.body.should =~ /To renew your subscription please visit/
end

Then /^that notification should have a link to subscriptions$/ do
  last_email = ActionMailer::Base.deliveries.last
  last_email.body.should =~ /To renew your subscription please visit/
end

When /^we expire subscriptions that finish today$/ do
  @subscription.update_attribute(:expires_on, Date.today)
  @subscriptions = Subscription.expiring_on(Date.today.to_date)
  @subscriptions.each do |subscription|
    AppliesSubscriptionGroups.remove(subscription, subscription.reader)
    NotifySubscriber.deliver_subscription_expired_email(subscription)
  end
end

Then /^the reader should be emailed an expiry notification$/ do
  last_email = ActionMailer::Base.deliveries.last
  last_email.to.should include @reader.email
    
  last_email.subject.should == "Your NZFFA subscription has expired"
  last_email.body.should =~ /Your subscription has expired/
  last_email.body.should =~ /To renew your subscription please visit/
end

Then /^the reader should not have FFT access anymore$/ do
  @reader.groups.should_not include @fft_marketplace_group
end
