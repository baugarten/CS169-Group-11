Feature: Create a project and view it
  As an admin
  So that I can make a project and receive donations
  I want to be to make a project and have users see it

  Background:
    Given the following projects exist
    | farmer  | description                                        | target | end_date | ending |
    | farmer1 | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | 400    | 1/1/2015 | true   |


  Scenario: Non-admins shouldn't add projects
    Given I am on the create project page
    Then I should be on the login admin page

  Scenario: See index
    Given I am on the projects index page
    Then I should see "farmer1"

  Scenario: Admins add projects
    Given I am logged in as an admin
    When I am on the create project page
    Then I should be on the create project page
    When I fill in "project_farmer" with "farmer2"
    And I fill in "Description" with "I don't have a description. I need at least 50 characters though or I will fail validation"
    And I fill in "Target" with "500"
    And I fill in "End date" with "1/1/2013"
    And I press "Create Project"
    Then I should be on the project details page for "farmer2"
    And I should see "farmer2"
    And I should see "$500"
    And I should see "I don't have a description"

  Scenario: Errors on bad project
    Given I am logged in as an admin
    When I am on the create project page
    Then I should be on the create project page
    When I fill in "project_farmer" with "farmer"
    And I fill in "Description" with "lasjd"
    When I press "Create Project"
    Then I should see "You must choose an end date"

  Scenario: Delete Project
    Given I am logged in as an admin
    When I am on the project details page for "farmer1"
    And I follow "Delete"
    Then I should be on the projects index page
    And I should not see "farmer1"

  Scenario: Edit a project
    Given I am logged in as an admin
    And I am on the edit page for "farmer1"
    And I fill in "Description" with "Hey I changed a description"
    And I fill in "End date" with "11/29/2015"
    And I press "Update Project"
    Then I should see "Hey I changed a description"

  Scenario: Edit a project failure
    Given I am logged in as an admin
    And I am on the edit page for "farmer1"
    And I fill in "Description" with "Hey I changed a description"
    And I fill in "project_end_date" with ""
    And I uncheck "project_ending"
    And I press "Update Project"
    Then I should see "You must choose an end date"
