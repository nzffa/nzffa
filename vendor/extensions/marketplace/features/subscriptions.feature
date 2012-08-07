Feature: Subscriptions
  Subscriptions are the way that NZFFA members belong to groups
  Subscriptions last for a year and all begin on the same date
  Readers can buy a subscription
  
  The price of a subscription depends on what membership choices the reader has made
  Readers buy subscriptions via the web interface, which calculates the price of the subscription as members make choices
  There needs to be a class that adds, removes groups from the reader depending on their subscription details


  When you sign up right away.. do you pay for a subscription upto the end of the year?

  Before:
    
  Scenario: user creates a subscription for the current year
    
  @reader_logged_in
  Scenario: user creates a subscription for next year
    When I visit new subscription
    And configure the subscription as a branch member
    And click create subscription
    Then I should see 'Subscription created successfully'
