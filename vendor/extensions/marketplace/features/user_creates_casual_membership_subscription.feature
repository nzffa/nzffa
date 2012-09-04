Feature: User creates casual membership subscription
  As someone interested in NZFFA
  In order stay upto date
  I need to create a Casual subscription

  Background:
    Given I am a registered, logged in reader
    And casual FFT Marketplace membership is $50/year
    And Tree Grower Magazine "New Zealand" is $40 / year
    And Tree Grower Magazine "Australia" is $50 / year
    And Tree Grower Magazine "Everywhere else" is $60 / year

  @javascript
  Scenario Outline: User creates Tree Grower Magazine subscription
    Given the date is "22 August 2012"
    When I visit new subscription
    And choose "Casual Membership"
    And click Next
    And choose "<duration>"
    And check "Subscribe to NZ Tree Grower Magazine"
    And choose "<tree_grower_delivery_location>"
    Then I should see "Subscription Fee: $<fee> + GST"
    And I should see "Begins on: <begin_date>"
    And I should see "Expires on: <expiry_date>"

    Scenarios:
      | tree_grower_delivery_location | duration  | fee   | begin_date      |  expiry_date    |
      | New Zealand                   | Full year | 40.00 | 1 January 2012 |31 December 2012 |
      | Australia                     | Full year | 50.00 | 1 January 2012 |31 December 2012 |
      | Everywhere else               | Full year | 60.00 | 1 January 2012 |31 December 2012 |
      | New Zealand                   | subscription_duration_remainder_of_year_plus_next_year | 80.00 | 22 August 2012 | 31 December 2013 |

  @javascript
  Scenario: User creates FFT Marketplace subscription for this year
    Given the date is "22 August 2012"
    When I visit new subscription
    And choose "Casual Membership"
    And click Next
    And check "subscription[belong_to_fft]"
    And choose "Full year"
    Then I should see "Subscription Fee: $50.00 + GST"
    And I should see "Begins on: 1 January 2012"
    And I should see "Expires on: 31 December 2012"
