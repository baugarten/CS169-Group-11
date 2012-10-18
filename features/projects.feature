Feature: Create a project and view it
  As an admin
  So that I can make a project and receive donations
  I want to be to make a project and have users see it

  Scenario: Non-admins shouldn't add projects
    Given I am on the create project page
    Then I should be on the login admin page

  Scenario: Admins add projects
    Given I am logged in as an admin
    When I am on the create project page
    Then I should be on the create project page
    When I fill in "project_farmer" with "farmer1"
    And I fill in "Description" with "I don't have a description"
    And I fill in "Target" with "500"
    And I fill in "End date" with "1/1/2013"
    And I press "Create Project"
    Then I should be on the project details page for "farmer1"
    And I should see "farmer1"
    And I should see "$500"
    And I should see "I don't have a description"
