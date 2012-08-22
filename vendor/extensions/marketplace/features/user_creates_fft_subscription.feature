Feature: User creates FFT subscription
  As an timber advertiser
  In order to list my products and services in the FFT Marketplace
  I need to create a FFT Marketplace subscription

  @javascript
  Scenario: User creates FFT Marketplace subscription for this year
    Given FFT Marketplace membership only is $50/year
    And the date is "22 August 2012"
    When I visit new subscription
    And choose "FFT Marketplace"
    And click Next
    Then I should see "FFT Marketplace Membership"
    When I choose "Full year"
    Then I should see "Subscription Fee: $50.00 + GST"
    And I should see "Expires on: 31 December 2012"
