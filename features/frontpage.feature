Feature: front page
  As a visitor
  So that I know what website I am on
  I want to see a front page

Background:
  Given I am on the home page

Scenario: have logo
  Then I should see picture of logo

Scenario: have picture of farmers 
  And I should see picture of farmers

Scenario: link to farmers page
  When I follow "All Farmers"
  Then I am on the farmers page

Scenario: link to login page
  When I follow "Login"
  Then I am on the login user page

Scenario: Star your campaign button
  When I press "Start Your Own Campaign" 
  Then I am on the Change Maker register page

Scenario: Register as Donor button
  When I press "Register as Donor"
  Then I am on the register user page

Scenario: have steps of how website works
  Then I should see "How it works"
