Feature: NZFFA Membership registation
  In order to join the FFT marketplace
  As a user
  I want to be able to sign up

  Background:
    Given there is a fft newsletter group
    And there is a FFT Marketplace group
    And there is a Full Membership group
    And there is a full members newsletter group

  Scenario: signing up to FFT marketplace
    When I visit membership register
    And enter my personal details
    And check "Receive Farm Forestry Timbers Newsletter"
    And click "Signup"
    Then I should get a registration email
    #Then I should be asked if I want to buy a subscription
    And I should belong to the Farm Forestry Timbers Newsletter Group
    #When I click "Buy subscription"
    #Then I should be taken to new subscription page
    
  Scenario: registered member checks their profile
    When I visit membership register
    And enter my personal details
    And click "Signup"
    When I visit membership register
    Then I should see my details in the form

  Scenario: registered member unsubscribes, subscribes to nzffa newsletter
    Given I am a registered, logged in reader
    And I belong to the full membership group
    When I visit membership register
    And I check "Receive NZFFA Members Newsletter"
    And I click "Save changes"
    Then I should belong to the NZFFA Members Newsletter group
    When I visit membership register
    And I uncheck "Receive NZFFA Members Newsletter"
    And I click "Save changes"
    Then I should not belong to NZFFA Members Newsletter group

  Scenario: registered user does not see password fields
    Given I am a registered, logged in reader
    When I visit membership register
    Then I should not see the password fields




