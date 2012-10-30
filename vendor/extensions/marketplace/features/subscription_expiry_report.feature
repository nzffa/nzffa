Feature: Subscriptions expiry report
  In order to be aware of people who stop subscribing to the nzffa
  As an administrator
  I want to see readers who let their subscriptions expire

  Background:
    Given I am a logged in admin of the system

  Scenario: Reader subscription expired 1 month ago
    Given a reader had a subscription that expired 1 months ago
    And they did not create a new subscription
    When I run the expiry report
    Then I should see the reader in the report

  Scenario: Reader subscription expired 1 month ago but they bought a new subscription
    Given a reader had a subscription that expired 1 month ago
    And they have a new active subscription
    When I run the expiry report
    Then I should not see the reader in the report
    
  Scenario: Reader subscription expired 4 months ago
    Given a reader had a subscription that expired 4 months ago
    And they did not create a new subscription
    When I run the expiry report
    Then I should not see the reader in the report
