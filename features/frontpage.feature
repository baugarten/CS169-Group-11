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
  Then I should see "All Farmers"

Scenario: link to login page
  Then I should see "Login"

Scenario: Star your campaign button
  Then I should see "Start Your Own Campaign" 

Scenario: Register as Donor button
  Then I should see "Register as Donor"

Scenario: have steps of how website works
  Then I should see "How It Works"