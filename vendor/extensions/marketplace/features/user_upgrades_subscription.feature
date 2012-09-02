Feature: User upgrades their subscription
  In order to upgrade my subscription after I have bought it
  As a user
  I need to be charged the difference between my old and new subscription.

  Background:
    Given admin levy is $34
    And ha of trees is 0-10 for $0, 11-40 for $51, and 41+ for $120
    And there is a branch "North Otago" for $10
    And there is a branch "South Canterbury" for $8
    And Farm Foresty Timbers Marketplace membership is $50
    And tree grower magazine subscription costs $80 per year for members
    And I am a registered, logged in reader

  Scenario Outline:
    When I buy a year long subscription for <first_config> on <first_date>
    #this part is edit subscription.. which pushes you to update
    #and in update we calculate the upgrade cost
    #and create an order for that, make them pay
    #and when they return and their subscription is fully paid we apply the security stuff.
    And I upgrade the subscription to <second_config> on <second_date>
    Then I should be charged the <upgrade_cost>

  Scenarios:
    | first_date | first_config | second_date | second_config       | upgrade_cost |
    | 2012-01-01 | only_fft     | 2012-01-01  | fft_and_tree_grower | 80           |
    | 2012-01-01 | only_fft     | 2012-02-25  | fft_and_tree_grower | 60           |
    | 2012-01-01 | only_fft     | 2012-05-15  | fft_and_tree_grower | 40           |
    | 2012-01-01 | only_fft     | 2012-08-15  | fft_and_tree_grower | 20           |
    | 2012-01-01 | only_fft     | 2012-11-15  | fft_and_tree_grower | 0            |

