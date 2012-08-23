Feature: User pays for subscription
  In order to make my subscription active
  As a subscriber
  I need to pay for my subscription

  Scenario: User creates subscription and pays for it
    Given I have configured a subscription
    When I click 'Proceed to payment'
    Then should see I am being charged the full amount
    When I enter my credit card details
    Then I should see that payment was successful
    And my subscription should be activated
