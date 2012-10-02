Feature: NZFFA Membership registation
  In order to join the FFT marketplace
  As a user
  I want to be able to sign up

  Scenario: signing up to FFT marketplace
    When I visit membership register
    And I signup
    Then I should get an email
    And it should have my password in it


