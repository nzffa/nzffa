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
    And there is a North Otago branch for $7
    And FFT Marketplace branch costs $15
    And tree grower subscription costs $50 per year for members

  @reader_logged_in
  Scenario: user creates a subscription for the year
    When I visit new subscription
    And select an NZFFA Membership
    And click Next
    Then I should see "NZFFA Membership"
    And choose "0 - 10ha"
    And select "Otago" from "subscription_main_branch"
    And check "List my business in the FFT Marketplace" 
    And choose "Subscribe until the end of 2012 and receive back issues of Treegrower Magazine."
    Then I should see "Subscription Fee: $100 + GST"
    And press "Proceed to payment"

  Scenario: user creates a subscription for the current year, with back issues
    they will be charged full rate.


  Scenario: user creates a subscription for remainder of year, and next year
    Join after first of june.
    option to get back issues and pay full amount for the year.

    Join after first of june and subscribe upto the end of next year. no back issues.
    Feb, May, August, November... 

