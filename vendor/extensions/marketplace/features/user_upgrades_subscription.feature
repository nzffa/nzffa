Feature: User upgrades their subscription
  In order to upgrade my subscription after I have bought it
  As a user
  I need to be charged the difference between my old and new subscription.

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
    And there is a FFT Marketplace group
    And there is a Full Membership group
    And there is a members newsletter group
    And I am a registered, logged in reader

  @javascript
  Scenario: upgrading from just fft to fft + tree grower
    Given I created a casual fft subscription at the start of the year
    And the date is "2012-06-01"
    When I visit "/subscriptions"
    And I follow "Modify"
    And I choose "Casual Membership"
    And I press "Next"
    And check "Subscribe to NZ Tree Grower Magazine"
    And choose "Australia"
    Then I should see "Begins on: 1 June 2012"
    And I should see "Expires on: 31 December 2012"
    And I should see "Subscription Price: $67.00 + GST"
    And I should see "Credit on current subscription: $42"
    And I should see "Upgrade Price: $25.00"
    And press "Proceed to payment"
    Then I should be forwarded to payment express
    And I should see "$25"
    When I enter my credit card details
    Then I should see that payment was successful
    And I should belong to the Tree Grower Magazine group
    And I should belong to the FFT Marketplace group
    And my original subscription should be cancelled
    And my new subscription should be active
    And the page should say thank you

  @javascript
  Scenario: upgrading from just fft to full membership
    # new sub price: admin levy 34
    #                40+ ha 120
    #                Taranaki 10 
    #                Waikato 4
    #                fft 15
    #                treegrower
    #                34 + 120 + 10 + 4 + 15 + 50
    Given I created a casual fft subscription at the start of the year
    And the date is "2012-06-01"
    When I visit "/subscriptions"
    And I follow "Modify"
    And I choose "Full Membership"
    And I press "Next"
    And I choose "40+ ha"
    And I select "Taranaki" from "subscription_main_branch_name" 
    And I select "Waikato" from "subscription_associated_branch_names"
    And wait a bit
    Then I should see "Subscription Price: $116.50 + GST"
    And I should see "Credit on current subscription: $42"
    And I should see "Begins on: 1 June 2012"
    And I should see "Expires on: 31 December 2012"
    And I should see "Upgrade Price: $74.50"
    And press "Proceed to payment"
    Then I should be forwarded to payment express
    And I should see "$74.50"
    When I enter my credit card details
    Then I should see that payment was successful
    And I should belong to the Tree Grower Magazine group
    And I should belong to the FFT Marketplace group
    And I should belong to the Full Membership group
    And my original subscription should be cancelled
    And my new subscription should be active
    And the page should say thank you
