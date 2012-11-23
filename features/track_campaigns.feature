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
  And I should see "$0.0 / $600"

Scenario: Following campaign manager should show campaign detail and be able to change them
  When I follow "Farmer1"
  Then the manager should be on the "Farmer1" page
  Then I should see "Hi <name>, please look at this video. <link>"
  Then I should see "http://www.youtube.com/watch?v=oHg5SJYRHA0"
  Then I should see "Bob Smith"
  Then I should see "bobsmith@gmail.com"
  When I follow "Change Template"
  Then the campaign should be on the "message template" page

Scenario: Campaign responses should be shown
  When I follow "Farmer1"
  Then the manager should be on the "Help Farmer1" page
  Then the manager should show "Bob Smith" have been sent the email
  Then the manager should show "Jack Black" have not been sent the email

Scenario: If the user trying to enter a invalid id the the browser address bar
  When I want to access the campaign with id "7723"
  Then I should see "Campaigns with id:7723 doesnt exist!!"

Scenario: Access other campaigns that you are not the owner
  Given another user created a campaign
  When I try to access the campaign not belong to me
  Then I should see "You may only view your campaigns"

Scenario: Delete the campaign 
  When I follow "Delete"
  Then I should see "Campaign was Deleted Successfully"

Scenario: Open the response link before the mail sent
  Given I opened the tracking response link "first" time
  Then I should see "Oh, I havent send the mail to you yet...."

Scenario: Open the response link after the mail sent
  Given I sent the email out to my fd already
  And I opened the tracking response link "first" time
  Then I should see "Thankyou for Confirmation"
  And I opened the tracking response link "second" time
  And I should see "You Already Confirmed You Read The Mail"

Scenario: campaigns can only opened if it not exist
  When I follow "Start a new campaign"
  Then I should not see "Farmer 1"
