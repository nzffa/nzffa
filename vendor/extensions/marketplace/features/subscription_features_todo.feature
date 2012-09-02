Scenario: Existing reader buys subscription
  I am the NZFFA admin person
  I have a paper subscription form, and cheque.
  I go to Readers plus index. find the reader for this person and click create subscription
  I fill in the subscription form to match the paper one.
  Then I see the order form, pre filled.
  I select cheque as payment method
  I enter the date of payment.
  And Save.

Scenario:
  I buy and pay for an FFT membership for 2012
  Later I decide to upgrade to NZFFA membership.
  So I go to my account page and click Upgrade Subscription
  I configure the subscription to how I want..
  And I am charged the additional amount.

Scenario:
  I have a subscription for 2012
  When I create a new subsription I should only see 2013 term.
