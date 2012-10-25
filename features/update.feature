Feature: Should have a update news
	As a user
	So that I know latest new of OneProsper
	I want to be see the update on homepage

Background:
	Given I am logged in as an admin
	And I am on the homepage

Scenario: Admin should see update news at homepage
	Then I should see "Latest News"

Scenario: Admin should be able to add a latest news	
	Given I am on the create update page
	Then I create a new update
	And I should see "Update created Successfully"

Scenario: Admin should be able to edit latest news
	Given I am on the edit page of an update
	When I edited successfully
	And I should see "Update edited Successfully"

Scenario: Admin should be able to delete the update
	Given I am on the edit page of an update
	When I confirmed the delete action
	Then I should see "Update deleted Successfully"

Scenario: Error message should pop up if title or not present when create
	Given I am on the create update page
	Then I submit the update with empty title or content
	And I should see "Error, Empty Title or Content"

Scenario: Error message should pop up if title or not present when edit
	Given I am on the edit update page
	Then I submit the update with empty title or content
	And I should see "Error, Empty Title or Content"



	

