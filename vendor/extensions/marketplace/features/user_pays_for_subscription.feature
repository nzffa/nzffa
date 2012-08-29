Feature: User pays for subscription
  In order to make my subscription active
  As a subscriber
  I need to pay for my subscription

  @javascript
  Scenario: User creates an FFT subscription and pays for it successfully
    Given I am a registered, logged in reader
    And there is a FFT group to identify FFT advertisers
    And I have configured an FFT subscription
    When I click 'Proceed to payment'
    Then I should be forwarded to payment express
    And should see I am being charged the full amount
    When I enter my credit card details
    Then I should see that payment was successful
    And I should have access to place an ad in the FFT Marketplace
