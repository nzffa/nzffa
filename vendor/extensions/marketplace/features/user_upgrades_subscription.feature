Feature: User upgrades their subscription
  In order to upgrade my subscription after I have bought it
  As a user
  I need to be charged the difference between my old and new subscription.

  Background:
    Given admin levy is $34
    And ha of trees is 0-10 for $0, 11-40 for $51, and 41+ for $120
    And there is a branch "North Otago" for $10
    And there is a branch "South Canterbury" for $8
    And Farm Foresty Timbers Marketplace membership is $50
    And tree grower magazine subscription costs $80 per year for members
    And I am a registered, logged in reader

  Scenario: upgrading from casual fft membership to full membership
    Given I have a casual fft membership
    When I visit subscriptions index
    And I click modify
    And I press "Full Membership"
    And I change my subscription to a full membership
    Then I should see "Confirm Subscription Upgrade"
    And I should see "You are upgrading from Casual Membership with Farm Forestry Timbers beginning 1st Feburary 2012 and expiring on 31st Decemeber 2012"
    And I should see "to Full Membership (1 branch) beginning 1st May 2012 and expiring on 31st Decemeber 2012"
    And I should see "Credit on current subscription: $50"
    And I should see "New subscription levy: $109"
    And I should see "Amount to pay: $59"


