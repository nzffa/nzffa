Feature: Admin creates subscription on behalf of an offline user
  In order to create a subscription for a user who does not have internet access
  As an administator of the system
  I want to create a subscription and record a cheque as payment

  Background:
    Given the date is "2012-01-01"
    Given I am a logged in admin of the system
    And there is a registered reader

    And admin levy is $10

    #casual membership
    And FFT Marketplace membership is $15 for casual members
    And Tree Grower Magazine "New Zealand" is $40 / year
    And Tree Grower Magazine "Australia" is $50 / year
    And Tree Grower Magazine "Everywhere else" is $60 / year

    #full membership
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

  @javascript
  Scenario: Admin creates casual subscription
    When I show the reader from readers plus
    Then I should see a create subscription button
    And visit create subscription
    And choose "Casual Membership"
    And click Next
    And check "subscription[belong_to_fft]"
    And fill in a manual expiry date
    Then I should see "Subscription Price: $25.00 + GST"
    When I click 'Proceed to payment'
    Then I should see an order form
    When I enter the payment method and date into the order form
    And I press "Save"
    Then I should see that the order for $25.00 was created successfully
    And the reader should belong to Farm Forestry Timbers Group

  #@javascript
  #Scenario: Admin creates full membership subscription
    #Given the date is "2012-01-01"
    #When I show the reader from readers plus
    #Then I should see a create subscription button
    #And visit create subscription
    #And choose "Full Membership"
    #And click Next
    #And choose "0 - 10ha"
    #And select "North Otago" from "subscription_main_branch_name"
    #And select "South Canterbury" from "subscription_associated_branch_names"
    #And select "Cypress Development Group" from "subscription_action_group_ids"
    #And check "Join Farm Forestry Timbers" 
    #Then I should see "Subscription Price: $114.00 + GST"
    #When I click 'Proceed to payment'
    #Then I should see an order form
    #And the order form should have 1 order line for fft
    #When I enter the payment method and date into the order form
    #And I press "Save"
    #Then I should see that the order for $12.50 was created successfully
    #And the reader should belong to Farm Forestry Timbers Group

  #Scenario: Admin edits subscription
    #Given the registered reader has a casual subscription
    #When I visit edit_admin_subscription for that sub
    #And I add tree grower to the subscription
    #And wait a bit
    #Then I should see an order form with a refund for the fft
    #And I should see a order lines for the new subscription
    #When I press "Save"
    #Then I should see that the subscription was upgraded.

  #Scenario: Admin indexes subscriptions
    #When I visit admin subscriptions
    #Then I should see a table of subscriptions

  #Scenario: Admin views reader subscription
    #When I show the reader from readers plus
    #Then I should see the readers subscription

