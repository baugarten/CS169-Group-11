Feature: Project pictures are uploaded on dropbox
  As an admin
  So that I can save hosting fees
  I want to be to upload project pictures to dropbox

  Background:
    Given the following projects exist
    | farmer  | description                                        | target | end_date | ending |
    | farmer1 | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | 400    | 1/1/2015 | true   |


  Scenario: Admins add projects with dropbox pic upload
    Given I am logged in as an admin
    When I am on the create project page
    Then I should be on the create project page
    When I fill in "project_farmer" with "farmer2"
    And I fill in "Description" with "I don't have a description. I need at least 50 characters though or I will fail validation"
    And I fill in "Target" with "500"
    And I fill in "End date" with "1/1/2013"
    And I attach the file "features/assets/test_picture.png" to dropbox
    And I press "Create Project"
    Then I should be on the project details page for "farmer2"
    And I should see "farmer2"
    And I should see "$500"
    And I should see "I don't have a description"
    Then I should see my picture linked from dropbox


  Scenario: Delete Project
    Given I am logged in as an admin
    When I am on the project details page for "farmer1"
    And I press "Delete"
    Then my picture should be deleted from dropbox


  Scenario: picture change on project edit
    Given I am logged in as an admin
    And I am on the edit page for "farmer1"
    And I attach the file "features/assets/test_picture.png" to dropbox
    Then my picture should be deleted from dropbox
    Then I should see my picture linked from dropbox



