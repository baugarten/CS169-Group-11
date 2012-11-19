Feature: Track Campaigns
  As a user
  So that I can keep track of all my active campaigns
  I want to see a campaign manager in my dashboard for all my campaigns

Background: User logged in and on homepage
  # canonical test data: "Mister Test" with email "test@email.com"
  Given I am logged in as the test user
  Given farmers have been created
  Given campaigns have been created
  And I am on the user dashboard

Scenario: Dashboard should show campaign status
  
  Then I should see "My Campaigns"
  
  And I should see "Farmer1"
  And I should see "Farmer2"
  And I should see "$0.0 / $500"

Scenario: Following campaign manager should show campaign detail and be able to change them
  When I follow "Farmer1"
  Then the manager should be on the "Farmer1" page
  Then I should see "Hi <name>, please look at this video. <link>"
  Then I should see "http://www.youtube.com/watch?v=oHg5SJYRHA0"
  Then I should see "Bob Smith"
  Then I should see "bobsmith@gmail.com"
  When I follow "Change Template"
  Then the campaign should be on the "message template" page

Scenario: Changing the Video Link
  When I follow "Farmer1"
  When I follow "Change Link"
  Then the campaign should be on the "record video" page

Scenario: Manage Friends
  When I follow "Farmer2"
  When I follow "Manage Friends"
  Then the campaign should be on the "enter friend" page

Scenario: Campaign responses should be shown
  When I follow "Farmer1"
  Then the manager should be on the "Help Farmer1" page
  Then the manager should show "Bob Smith" have not been sent the email

  Then the manager should show "Jack Black" have been sent the email

Scenario: Email should have the correct fields and changes confirmation status
  When I follow "Farmer1"
  Then I follow "Send Now"
  Then the page should have "mailto:bobsmith@gmail.com"
  

