Feature: Admin downloads a CSV of payments
  In order to update MYOB properly
  I want to get a csv report of payment information

  Background:
    Given admin levy is $34
    And ha of trees is 0-10 for $0, 11-40 for $51, and 41+ for $120
    And there is a branch "North Otago" for $10
    And there is a branch "South Canterbury" for $8
    And FFT Marketplace membership is $15 for full members
    And FFT Marketplace membership is $50 for casual members
    And Tree Grower Magazine is $50 for full members
    And Tree Grower Magazine "New Zealand" is $40 / year
    And Tree Grower Magazine "Australia" is $50 / year
    And Tree Grower Magazine "Everywhere else" is $60 / year
    And Eucalyptus Action Group is $30
    And there is a Tree Grower Magazine group
    And there is a FFT Marketplace group
    And there is a Full Membership group
    #new stuff
    Given there is a reader called John Tree
    And there is a reader called Helen Bark
    And John Tree created a full membership
    And Helen Bark created a casual membership
    And Helen Bark upgraded her casual membership
    And I am a logged in admin of the system

  Scenario: Payments report shows payments
    When I download the payment report
    Then I should see a payment from John Tree
    And I should see a payment from Helen Bark

  Scenario: Allocations report shows allocations
    When I download the allocations report
    Then I should see an allocation to North Otago for 10 from JT's payment

  Scenario: Allocations report shows refunds
    When I download the allocations report
    Then I should see an allocation refund of 
    #And I from JTs payment I should see an allocation to South Canterbury for 8
    #And I from JTs payment I should see an allocation to Eucalyptus Action Group for 30
    #And I from JTs payment I should see an allocation to Admin Levy for something
    #And I from JTs payment I should see an allocation to Forest Area for 51
    #And I should see a payment from Helen Bark
    #And from HBs payment I should see an allocation to NZ Tree Grower Magazine for 
    #And I should see an allocation to tree grower magazine
