Feature: Edit user profile
	As a user,
	So that I can change my info,
	I want to be able to update my profile

Background: User logged in and on profile page
	# canonical test data: "Mister Test" with email "test@email.com" with no picture
	Given I am logged in as the test user
	And I am on the user dashboard
	When I follow "Edit Profile"
	Then I should be on the edit profile page

Scenario: User change name/email/username
	When I fill in "First Name" with "Bob"
	And I fill in "Last Name" with "Smith"
	And I fill in "Email" with "bobsmith@gmail.com"
	And I fill in "Nickname" with "BSmith"
	And I press "Save"
	Then I should be on the user dashboard
  And I should see "Profile updated successfully"
	And I should see "Bob Smith"
	And I should see "bobsmith@gmail.com"
	And I should see "BSmith"
	And I should not see "Mister Test"
	And I should not see "test@email.com"
	
Scenario: User change email - sad path
	When I fill in "Email" with "marysmithgmail.com"
  And I press "Save"
	Then I should be on the edit profile page
	And I should see "email: is invalid"
  
Scenario: User change password - sad path
	When I fill in "Password" with "password"
  And I fill in "Confirm" with "password123"
  And I press "Save"
	Then I should be on the edit profile page
	And I should see "password: doesn't match confirmation"