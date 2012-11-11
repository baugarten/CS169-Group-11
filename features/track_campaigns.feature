Feature: Track Campaigns
  As a user
  So that I can keep track of all my active campaigns
  I want to see a campaign manager in my dashboard for all my campaigns

Background: User logged in and on homepage
  # canonical test data: "Mister Test" with email "test@email.com"
  Given I am logged in as the test user
  Given that campaigns have been created

Scenario: Dashboard should show campaign status
  Then I should see "My Campaigns"
  And I should see "Help Farmer1"
  And I should see "Help Farmer2"

Scenario: Following campaign manager should show campaign detail
  When I follow "Help Farmer1"
	Then the manager should be on the "Help Farmer1" page
  Then I should see "Help Farmer1"
  Then I should see "Hi <name>, please look at this video. <link>"
  Then I should see "http://www.youtube.com/watch?v=oHg5SJYRHA0"

Scenario: Campaign responses should be shown
  When I follow "Help Farmer1"
	Then the manager should be on the "Help Farmer1" page
  Then the manager should show "Bob Smith" have been sent the email
  Then the manager should show "Bob Smith" have donated "$10"
  Then the manager should show "Jack Black" have not been sent the email
  Then the manager should show "Jack Black" have donated "$0"
