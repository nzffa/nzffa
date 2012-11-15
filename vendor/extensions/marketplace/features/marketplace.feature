Feature: The NZFFA Marketplace (this spec was written after the marketplace)
  
  Background:
    Given I am a registered, logged in reader
    And I am a member of the FFT Group

  Scenario: I create an advert
    When I visit new_advert_path
    And I enter a new advert
    And I click Save
    Then I should be taken to 'My Adverts'

  Scenario: I update an advert
    Given I already have an advert
    When I visit edit advert
    And I click Save
    Then I should be taken to 'My Adverts'

  Scenario: I create a company listing
    When I visit edit_company_lisiting
    And I enter a company listing
    And I click Save
    Then I should be taken to 'My Adverts'

  Scenario: I update my company listing
