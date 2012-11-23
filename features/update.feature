Feature: Should have a update news
	As a user
	So that I know latest new of OneProsper
	I want to be see the update on homepage

Background:
	Given the following updates exist:
	| title       | content                    |
        | Test Update | The content of Test Update |
 
	Given I am logged in as an admin
	And I am on the homepage

Scenario: Admin should see update news at homepage
	Then I should see "Updates"

Scenario: Admin should be able to add a latest news	
	Given I am on the create update page
	Then I create a new update
	And I should see "Update was created successfully"

Scenario: Admin should be able to edit latest news
	Given I am on the update edit page of "Test Update"
	When I edited successfully
	And I should see "Update was edited successfully"

Scenario: Any user can view the detail of an update or latest news
	Given I am on the update index page
        When I choose to read more about "Test Update"
        Then I should see the complete content of "Test Update"

Scenario: Error message should pop up if title or content not present when create
	Given I am on the create update page
	And I submit the update with empty title or content
	Then I should see "Title can't be blank"
        And I should see "Content can't be blank"

Scenario: Error message should pop up if title or content not present when edit
	Given I am on the update edit page of "Test Update"
	Then I submit the update with empty title or content
	And I should see "Title can't be blank"
        And I should see "Content can't be blank"



	

