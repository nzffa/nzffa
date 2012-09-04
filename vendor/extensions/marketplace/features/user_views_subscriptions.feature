Feature: User views their subscriptions
  In order to know what subscriptions I have
  as a user
  I want to view a list of my subscriptions

  Background:
    Given I am a registered, logged in reader

  Scenario:
    Given I have a subscription for this year
    And I have a subcription for next year
    When I visit my subscriptions page
    Then I should see both subscriptions


