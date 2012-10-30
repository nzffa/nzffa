Feature: Tree Grower Deliveries Report
  In order to know where to send the Tree Grower Magazines
  As an administrator
  I want to see a report with delivery details for tree grower magazine

  Scenario: A reader is subscribed for 2012
    Given I am a logged in admin of the system
    And there is a reader with a treegrower subscription for 2012
    When the date is "2012-01-01"
    And we run the tree grower report
    Then the reader name and postal address should be listed
    And the reader should get 1 copy of tree grower magazine
