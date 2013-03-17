Feature: Group Secretary can admin group readers
  Scenario: Group group secretary loads group admin index
    Given there is an Otago branch and group and a member
    And I am logged in as the Otago group secretary
    When I visit the Otago branch secretary index
    Then I should see a list of readers who are members of the otago branch

  Scenario: Group group secretary updates reader
    Given there is an Otago branch and group and a member
    And I am logged in as the Otago group secretary
    When I visit the Otago branch secretary index
    And I click edit next to the first reader in the list
    And I change their name
    And I click Save
    Then I should see that the reader was updated

  Scenario: Non secretary is redirected from branch admin index
    Given there is an Otago branch and group and a member
    And I am logged in as a reader who is not a secretary
    When I visit the Otago branch secretary index
    Then I should be redirected somewhere
