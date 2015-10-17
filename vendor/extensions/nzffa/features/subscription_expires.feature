Feature: Subscription Expires, restricting access and notifying users.
  In order to ensure that people renew their subscriptions
  They should expire.

  Background:
    Given there is a registered reader
    And FFT Marketplace membership is $50 for casual members
    And Tree Grower Magazine "New Zealand" is $40 / year
    And Tree Grower Magazine "Australia" is $50 / year
    And Tree Grower Magazine "Everywhere else" is $60 / year
    And there is a Tree Grower Magazine group
    And there is a FFT Marketplace group
    And the date is "2012-09-12"

  Scenario: Subscription is due to expire in 30 days
    Given the reader's subscription is due to expire in 30 days
    When we warn all the soon to be expiring subscribers
    Then the reader should be emailed a warning notification
    And that notification should have a link to subscriptions

  Scenario: Subscription expires today.
    Given the reader's subscription is due to expire today
    When we expire subscriptions that finish today
    Then the reader should be emailed an expiry notification
    And the reader should not have FFT access anymore
    
