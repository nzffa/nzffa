Feature: Subscriptions
  Subscriptions are the way that NZFFA members belong to groups
  Subscriptions last for a year and all begin on the same date
  Readers can buy a subscription
  
  The price of a subscription depends on what membership choices the reader has made
  Readers buy subscriptions via the web interface, which calculates the price of the subscription as members make choices
  There needs to be a class that adds, removes groups from the reader depending on their subscription details


  When you sign up right away.. do you pay for a subscription upto the end of the year?
  Background:
    Given admin levy is $34
    And ha of trees is 0-10 for $0, 11-40 for $51, and 41+ for $120
    And there is a branch "North Otago" for $10
    And there is a branch "South Canterbury" for $8
    And Farm Foresty Timbers Marketplace membership is $15
    And tree grower magazine subscription costs $50 per year for members

  @reader_logged_in
  @javascript
  Scenario: user creates a subscription for the year config 1
    Given the date is "1st january 2012"
    When I visit new subscription
    And select an NZFFA Membership
    And click Next
    Then I should see "NZFFA Membership"
    And choose "0 - 10ha"
    And select "North Otago" from "subscription_main_branch_name"
    And select "South Canterbury" from "subscription_associated_branch_names"
    And check "List my business in the FFT Marketplace" 
    And choose "Full year"
    Then I should see "Subscription Fee: $117 + GST"
    And press "Proceed to payment"

  @javascript
  Scenario: user creates a subscription for the year config 2
    Given the date is "1st january 2012"
    When I visit new subscription
    And select an NZFFA Membership
    And click Next
    Then I should see "NZFFA Membership"
    And choose "11 - 40ha"
    And select "South Canterbury" from "subscription_main_branch_name"
    And select "North Otago" from "subscription_associated_branch_names"
    And choose "Full year"
    Then I should see "Subscription Fee: $153 + GST"
    And I should see "Expires on: 31 December 2012"
    And press "Proceed to payment"

  @wip
  @javascript
  Scenario: user signs up for remaining quarter of the year, and next year
    Given the date is "1st november 2011"
    And I signup with 0-10ha, main branch North Otago, and join FFT
    When I choose "Remainder of year plus next year"
    Then I should see "Subscription Fee: $136.25"
    And I should see "Expires on: 31 December 2012"
    #Then I should be charged 1 and a quarter amount (turn literal)
    #And I should be added to north otago, fft, and admin levy groups

  #Scenario: user signs up for remaining half of the year, and next year
    #Given the date is "1st may 2012"
    #And I signup for a pretty normal looking membership and stop without setting a duration
    #When I select "Remainder of year plus next year"
    #Then I should see "Subscription Fee: $next years amount"
    #And I should see "Expires on: 31 December 2013"

  #Scenario: user signs up for remaining tree quarters of the year, and next year
    #Given the date is "1st april 2012"
    #And I signup for a pretty normal looking membership and stop without setting a duration
    #When I select "Remainder of year plus next year"
    #Then I should see "Subscription Fee: $next years amount"
    #And I should see "Expires on: 31 December 2013"
