Feature: Campaign Wizard
	As a user,
	To get a campaign started,
	I would like a campaign wizard

Background: User logged in and on profile page
	# canonical test data: "Farmer1", "Farmer2"
	Given farmers have been created
	# canonical test data: "Mister Test" with email "test@email.com" with no picture
	And I am logged in as the test user
	And I am on the user dashboard

Scenario: Complete a campaign and able to edit it
	When I follow "Start a new campaign"

	Then the campaign should be on the "select farmer" page
	When I follow "Farmer1"

	Then the campaign should be on the "enter friends" page
  When I fill in "Friend" with "My Friend <myfriend@bunkmail.com>"
  And I choose "link"
  And I fill in "Video Link" with "ajshdlkjahdskf"
  And I press "Next"
  And I fill in "Friend" with "Admiral Crunch <friend2@bunkmail.com>"
  And I choose "link"
  And I fill in "Video Link" with "kliusljgsjdfng"
	And I press "Next"
  And I follow "Finished"
  Then the campaign should be on the "message template" page

  When I fill in "Subject" with "Help farmers in India!"
	And I fill in "Template" with "Hi <name>, please watch this video about funding farmers <link>! Thanks!"
	And I press "Next"

	Then the campaign should be on the "send messages" page
	And I should see "Hi <name>, please watch this video about funding farmers <link>! Thanks!"
	And I should see "My Friend"
	And I should see "Admiral Crunch"
  And I should see /[contains(@href,myfriend@bunkmail.com)]/
  And I should see /[contains(@href,friend2@bunkmail.com)]/

  Given I am on the user dashboard
  When I follow "Edit"
	And I should see "Hi <name>, please watch this video about funding farmers <link>! Thanks!"
	And I should see "My Friend"
	And I should see "Admiral Crunch"
  And I should see "myfriend@bunkmail.com"
  And I should see "friend2@bunkmail.com"
  And I fill in "Template" with "testing editing 123!"
	And I press "Update Campaign Info"
  And I should see "Campaign was successfully updated"
  And I should see "testing editing 123!"
  And I fill in "Template" with ""
  And I press "Update Campaign Info"
  Then I should see "Please Enter the Template Content"

Scenario: Should notify you on invalid emails
	When I follow "Start a new campaign"

	Then the campaign should be on the "select farmer" page
	When I follow "Farmer1"
	Then the campaign should be on the "enter friends" page
  When I fill in "Friend" with "My Friend <myfriend@bunkmail.com>" 
  And I choose "link"
  And I fill in "Video Link" with "KAJSHDKLAJSHD"
  And I press "Next"
  And I fill in "Friend" with "Admiral Crunch <friend2@bunkmail.com>"
  And I choose "link"
  And I fill in "Video Link" with "KAJSHDKLAJSHD"
  And I press "Next"
  And I fill in "Friend" with "OMG Not EMAIL, quack quack"
  And I choose "link"
  And I fill in "Video Link" with "KAJSHDKLAJSHD"
  And I press "Next"
  Then the campaign should be on the "enter friends" page
  And I should see "Your last friend wasn't correct"

Scenario: Must enter something for friends email page
  When I follow "Start a new campaign"
	Then the campaign should be on the "select farmer" page
	When I follow "Farmer1"
	Then the campaign should be on the "enter friends" page
	And I press "Next"
  Then I should see "last friend wasn't correct"

Scenario: Must enter something for video page
  When I follow "Start a new campaign"
	Then the campaign should be on the "select farmer" page
	When I follow "Farmer1"
	Then the campaign should be on the "enter friends" page
  When I fill in "Friend" with "My Friend <myfriend@bunkmail.com>"
  And I press "Next"
  And I press "Next"
  Then I should see "Your last friend wasn't correct"

Scenario: Template content input check 
  Given we are on the template page
  Then the campaign should be on the "message template" page
  And I press "Next"
  Then I should see "Please Enter the Subject and Content"
  When I fill in "Subject" with "Help farmers in India!"
	And I press "Next"
  Then I should see "Please Enter the Template Content"

Scenario: Template content input check
  Given we are on the template page
  Then the campaign should be on the "message template" page
  And I fill in "Template" with "Hi <name>, please watch this video about funding farmers <link>! Thanks!"
  And I press "Next"
  Then I should see "Please Enter the Template Subject"

Scenario: Session check before create Campaign
  Given go directly to template page
  And I fill in "Subject" with "Help farmers in India!"
  And I fill in "Template" with "Hi <name>, please watch this video about funding farmers <link>! Thanks!"
  And I press "Next"
  Then I should see "Incomplete information to create a campaign"

Scenario: Access filling in Friends's email page without selecting a farmer
  Given We are at the fill in friend's email page
  And I should see "Please Select a Farmer"
