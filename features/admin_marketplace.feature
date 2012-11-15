Feature: Admin manages the NZFFA marketplace

  Background:
    Given I am a registered, logged in admin

  Scenario: Create an advert on behalf of a reader
    When I visit new_admin_advert_path
    And I fill in the admin advert form
    Then I should see advert created successfully
