Feature: User creates full NZFFA Membership
  NZFFA Membership means you belong to a NZFFA Branch.

  The price of a subscription depends on what membership choices the reader has made
  Readers buy subscriptions via the web interface, which calculates the price of the subscription as members make choices
  There needs to be a class that adds, removes groups from the reader depending on their subscription details

  Background:
    Given admin levy is $34
    And ha of trees is 0-10 for $0, 11-40 for $51, and 41+ for $120
    And there is a branch "North Otago" for $10
    And there is a branch "South Canterbury" for $8
    And FFT Marketplace membership is $15 for full members
    And Tree Grower Magazine is $50 for full members
    And Eucalyptus Action Group is $30
    And there is a Tree Grower Magazine group
    And there is a FFT Marketplace group
    And there is a Full Membership group
    And there is a full members newsletter group
    And I am a registered, logged in reader

  @javascript @wip
  Scenario: user creates a yearly subscription config 1
    Given the date is "2012-01-01"
    When I visit new subscription
    And select a Full Membership
    And click Next
    Then choose "0 - 10ha"
    And select "North Otago" from "subscription_main_branch_name"
    And select "South Canterbury" from "subscription_associated_branch_names"
    And check "Join Farm Forestry Timbers" 
    And choose "End of this year"
    Then I should see "Subscription Price: $117.00 + GST"
    And press "Proceed to payment"
    Then I should be forwarded to payment express
    When I enter my credit card details
    Then I should see that payment was successful
    And I should be asked to update my tree grower company listing
    And I should belong to the Tree Grower Magazine group
    And I should belong to the FFT Marketplace group
    And I should belong to the Full Membership group

  @javascript
  Scenario: user configures a yearly subscription config 2
    Given the date is "2012-01-01"
    When I visit new subscription
    And select a Full Membership
    And click Next
    Then choose "11 - 40ha"
    And select "South Canterbury" from "subscription_main_branch_name"
    And select "North Otago" from "subscription_associated_branch_names"
    And choose "End of this year"
    Then I should see "Subscription Price: $153.00 + GST"
    And I should see "Expires on: 31 December 2012"
    And press "Proceed to payment"
    Then I should be forwarded to payment express
    When I enter my credit card details
    Then I should see that payment was successful
    And I should belong to the Tree Grower Magazine group
    And I should belong to the Full Membership group

  @javascript
  Scenario: user configures a yearly subscription config 3
    Given the date is "2012-01-01"
    When I visit new subscription
    And select a Full Membership
    And click Next
    Then choose "11 - 40ha"
    And select "South Canterbury" from "subscription_main_branch_name"
    And choose "End of this year"
    And select "Eucalyptus Action Group" from "subscription_action_group_ids"
    Then I should see "Subscription Price: $173.00 + GST"
    And I should see "Expires on: 31 December 2012"
    And press "Proceed to payment"
    Then I should be forwarded to payment express
    When I enter my credit card details
    Then I should see that payment was successful
    And I should belong to the Tree Grower Magazine group
    And I should belong to the Full Membership group
    And I should belong to the Eucalyptus Action group
    And I should belong to the NZFFA Members Newsletter group

  #Scenario Outline:
    #user configures their subscription and gets the right price
    #(full year subscriptions only)
    #Then choose "<area>"
    #And select "<main_branch>" from "subscription_main_branch_name"
    #And select "<associated_branch>" from "subscription_associated_branch_names"
    #And check "List my business in the FFT Marketplace" if <join_fft>
    #And choose "Full year"
    #Then the Subscription Fee should be "<fee>"

    #Scenarios:
      #| area      | main_branch | associated_branch | join_fft | price |
      #| 0 - 10ha  | North Otago | South Canterbury  | yes      | 117   |
      #| 11 - 40ha | North Otago | South Canterbury  | yes      | 168   |


  @javascript
  Scenario Outline: user signs up on different dates and gets different
    fees and expiry dates when using 'End of next year'

    Given the date is "<signup_on>"
    When I visit new subscription
    And select a Full Membership
    And click Next
    When I signup with 0-10ha, main branch North Otago, and join FFT
    And I choose "End of next year"
    Then the expiry date should be "<expires_on>"
    Then the Subscription Price should be "<fee>"

  @javascript
  Scenarios:
      | signup_on  | fee    | expires_on |
      | 2012-01-01 | 218.00 | 2013-12-31 |
      | 2012-02-14 | 218.00 | 2013-12-31 |
      | 2012-02-15 | 190.75 | 2013-12-31 |
      | 2012-05-14 | 190.75 | 2013-12-31 |
      | 2012-05-15 | 163.50 | 2013-12-31 |
      | 2012-08-14 | 163.50 | 2013-12-31 |
      | 2012-08-15 | 136.25 | 2013-12-31 |
      | 2011-11-01 | 136.25 | 2012-12-31 |
      | 2011-11-14 | 136.25 | 2012-12-31 |
      | 2011-11-15 | 109.00 | 2012-12-31 |
      | 2012-12-30 | 109.00 | 2013-12-31 |
      
  # dont show full year option if 0 remaining quarters
  # make sure year numbers are correct in hint text on duration


