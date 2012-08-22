Feature: User creates Tree Grower subscription
  As someone interested in NZFFA
  In order stay upto date
  I need to create a NZ Tree Grower Magazine subscription

  @javascript
  Scenario Outline: User creates Tree Grower Magazine subscription
    Given Tree Grower Magazine "within New Zealand" is $40 / year
    Given Tree Grower Magazine "within Austraila" is $50 / year
    Given Tree Grower Magazine "Everywhere else" is $60 / year
    And the date is "22 August 2012"
    When I visit new subscription
    And choose "Tree Grower Magazine"
    And click Next
    Then I should see "NZ Tree Grower Magazine"
    When I choose "<tree_grower_delivery_location>"
    When I choose "<duration>"
    Then I should see "Subscription Fee: $<fee> + GST"
    And I should see "Expires on: <expiry_date>"

    Scenarios:
      | tree_grower_delivery_location | duration  | fee   | expiry_date      |
      | New Zealand                   | Full year | 40.00 | 31 December 2012 |
      | Australia                     | Full year | 50.00 | 31 December 2012 |
      | Everywhere else               | Full year | 60.00 | 31 December 2012 |
      | New Zealand                   | Remainder of year plus next year | 50.00 | 31 December 2013 |
