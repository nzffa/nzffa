Feature: User upgrades their subscription
  In order to upgrade my subscription after I have bought it
  As a user
  I need to be charged the difference between my old and new subscription.

  Background:
    Given admin levy is $34
    And ha of trees is 0-10 for $0, 11-40 for $51, and 41+ for $120
    And there is a branch "North Otago" for $10
    And there is a branch "South Canterbury" for $8
    And FFT Marketplace membership is $15 for full members
    And Tree Grower Magazine is $50 for full members
    And there is a Tree Grower Magazine group
    And there is a FFT Marketplace group
    And there is a Full Membership group
    And I am a registered, logged in reader

  @javascript
  Scenario: upgrading from casual fft membership to full membership
    Given I created a casual fft subscription at the start of the year
    And the date is "2012-06-01"
    When I visit "/subscriptions"
    And I follow "Modify"
    And I choose "Casual Membership"
    And I press "Next"
    And check "Subscribe to NZ Tree Grower Magazine"
    And choose "Australia"
    Then I should see "Subscription Fee: $50.00 + GST"
    And I should see "Credit on current subscription: $25"
    And I should see "Begins on: 1 June 2012"
    And I should see "Expires on: 31 December 2012"
    And I should see "Amount to pay: $59"
    # and I pay the right amount via dps
    # and I should belong to both groups


