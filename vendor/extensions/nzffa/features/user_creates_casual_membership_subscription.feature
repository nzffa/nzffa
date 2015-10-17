Feature: User creates casual membership subscription
  As someone interested in NZFFA
  In order stay upto date
  I need to create a Casual subscription

  Background:
    Given I am a registered, logged in reader
    And admin levy is $34
    And FFT Marketplace membership is $15 for casual members
    And Tree Grower Magazine "New Zealand" is $40 / year
    And Tree Grower Magazine "Australia" is $50 / year
    And Tree Grower Magazine "Everywhere else" is $60 / year
    And there is a Tree Grower Magazine group
    And there is a Tree Grower Magazine Australia group
    And there is a FFT Marketplace group

  @javascript 
  Scenario: User subscribes to FFT Marketplace only
    Given the date is "2012-01-01"
    When I visit new subscription
    And choose "Casual Membership"
    And click Next
    And check "Join Farm Forestry Timbers"
    And choose "End of this year"
    And wait a bit
    Then I should see "Subscription Price: $49.00 + GST"
    And I should see "Begins on: 1 January 2012"
    And I should see "Expires on: 31 December 2012"
    When I click 'Proceed to payment'
    Then I should be forwarded to payment express
    When I enter my credit card details
    Then I should see that payment was successful
    And I should belong to the FFT Marketplace group

  @javascript
  Scenario: User subscribes to two get 2 copies of tree grower magazine in australia
    Given the date is "2012-01-01"
    When I visit new subscription
    And choose "Casual Membership"
    And click Next
    And check "Subscribe to NZ Tree Grower Magazine"
    And change number of copies to 2
    And choose "Australia"
    And choose "End of this year"
    And wait a bit
    Then I should see "Subscription Price: $100.00 + GST"
    When I click 'Proceed to payment'
    Then I should be forwarded to payment express
    When I enter my credit card details
    Then I should see that payment was successful
    And I should be subscribed to get 2 copies of NZ Tree Grower Magazine
    And I should belong to the Tree Grower Magazine Australia group

  #@javascript
  #Scenario Outline: User creates Tree Grower Magazine subscription
    #Given the date is "2012-01-01"
    #When I visit new subscription
    #And choose "Casual Membership"
    #And click Next
    #And choose "<duration>"
    #And check "Subscribe to NZ Tree Grower Magazine"
    #And choose "<tree_grower_delivery_location>"
    #Then I should see "Subscription Price: $<fee> + GST"
    #And I should see "Begins on: <begin_date>"
    #And I should see "Expires on: <expiry_date>"
    #When I click 'Proceed to payment'
    #Then I should be forwarded to payment express
    #When I enter my credit card details
    #Then I should see that payment was successful
    #And I should belong to the Tree Grower Magazine group
    #And I should be subscribed to get 1 copies of NZ Tree Grower Magazine

    #Scenarios:
      #| tree_grower_delivery_location | duration         | fee   | begin_date     |  expiry_date    |
      #| New Zealand                   | End of this year | 40.00 | 1 January 2012 | 31 December 2012 |
      #| Australia                     | End of this year | 50.00 | 1 January 2012 | 31 December 2012 |
      #| Everywhere else               | End of this year | 60.00 | 1 January 2012 | 31 December 2012 |
      #| New Zealand                   | End of next year | 80.00 | 1 January 2012 | 31 December 2013 |

  #@javascript
  #Scenario: User creates FFT Marketplace subscription for this year
    #Given the date is "2012-01-01"
    #When I visit new subscription
    #And choose "Casual Membership"
    #And click Next
    #And check "subscription[belong_to_fft]"
    #And choose "End of this year"
    #Then I should see "Subscription Price: $50.00 + GST"
    #And I should see "Begins on: 1 January 2012"
    #And I should see "Expires on: 31 December 2012"
    #When I click 'Proceed to payment'
    #Then I should be forwarded to payment express
    #When I enter my credit card details
    #Then I should see that payment was successful
    #And I should belong to the FFT Marketplace group

