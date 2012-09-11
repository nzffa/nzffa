Feature: User views their subscriptions
  In order to know what subscriptions I have
  as a user
  I want to view a list of my subscriptions

  Background:
    Given I am a registered, logged in reader

  Scenario: I see my active subscription and can modify it
    Given I created a casual fft subscription at the start of the year
    And the date is "2012-05-03"
    When I visit "/subscriptions"
    Then I should see the subscription details
    And I should see "Modify"

  Scenario: I have no subscriptions and can buy one
    When I visit "/subscriptions"
    Then I should see "You have no active subscription"
    And I should see "Buy a subscription"



