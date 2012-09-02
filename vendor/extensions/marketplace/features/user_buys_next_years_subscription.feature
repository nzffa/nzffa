Feature: User buys a subscription to begin and end in the next year
  In order to buy a subscription for next year's tree grower magazine
  When it is still 2012
  I need to be able to buy a subscription beginning next year

  Scenario:
    Given I have an active subscription for 2012
    And the date is 30th May 2012
    When I create a new subscription it should be for 2013
