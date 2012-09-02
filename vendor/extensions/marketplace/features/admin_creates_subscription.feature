Feature: Admin creates subscription on behalf of an offline user
  In order to create a subscription for a user who does not have internet access
  As an administator of the system
  I want to create a subscription and record a cheque as payment

  Background:
    Given I am an admin of the system
    And I am logged in
    And there is a registered reader

  Scenario: Admin views reader subscriptions
    When I show the reader from readers plus
    Then I should see a list of the readers subscriptions

  Scenario: Admin creates reader subscription
    When I show the reader from readers plus
    Then I should see a create subscription button
    When I create a subcription on behalf of the reader
    Then I should see an order form
    When I enter the payment method and amount into the order form
    Then I should see that the subscription was created successfully.
