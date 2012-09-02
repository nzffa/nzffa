Feature: User creates casual membership subscription
  As someone interested in NZFFA
  In order stay upto date
  I need to create a Casual subscription

  Background:
    Given I am a registered, logged in reader
    And FFT Marketplace membership only is $50/year
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
    And I should see "Expires on: <expiry_date>"

    Scenarios:
      | tree_grower_delivery_location | duration  | fee   | expiry_date      |
      | New Zealand                   | Full year | 40.00 | 31 December 2012 |
      | Australia                     | Full year | 50.00 | 31 December 2012 |
      | Everywhere else               | Full year | 60.00 | 31 December 2012 |
      | New Zealand                   | subscription_duration_remainder_of_year_plus_next_year | 50.00 | 31 December 2013 |

  #@javascript
  #Scenario: User creates FFT Marketplace subscription for this year
    #Given the date is "22 August 2012"
    #When I visit new subscription
    #And choose "Casual Membership"
    #And click Next
    #And choose "Full year"
    #And choose "List my business in the FFT Marketplace"
    #Then I should see "Subscription Fee: $50.00 + GST"
    #And I should see "Expires on: 31 December 2012"
