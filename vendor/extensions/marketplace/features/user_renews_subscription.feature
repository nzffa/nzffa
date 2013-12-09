Feature: User renews their subscription for the following year
  Background:
    Given admin levy is $34
    And ha of trees is 0-10 for $0, 11-40 for $51, and 41+ for $120
    And there is a branch "North Otago" for $10
    And there is a branch "South Canterbury" for $8
    And there is a branch "Taranaki" for $10
    And there is a branch "Waikato" for $4
    And FFT Marketplace membership is $15 for full members
    And FFT Marketplace membership is $50 for casual members
    And Tree Grower Magazine is $50 for full members
    And Tree Grower Magazine "Australia" is $50 / year
    And there is a Tree Grower Magazine group
    And there is a Tree Grower Magazine Australia group
    And there is a FFT Marketplace group
    And there is a Full Membership group
    And there is a members newsletter group
    And I am a registered, logged in reader

  @javascript
  Scenario: User renews their full membership for next year
    Given the date is "2013-12-07"
    And I have a full subscription for the current year
    When I visit membership details
    And click to renew my subscription for 2014
    And use the same subscription details
    And press "Proceed to payment"
    Then I should be forwarded to payment express
    When I enter my credit card details
    Then I should see that payment was successful
    Then I should have a subscription for the current year and the next year
