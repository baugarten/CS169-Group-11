Feature: User Dashboard
  As a user,
  So that I can track my donations and campaign status,
  I would like to have a dashboard.

Background: User logged in and on homepage
  # canonical test data: "Mister Test" with email "test@email.com"
  Given I am logged in as the test user
  And I am on the user dashboard
  
Scenario: Clicking on dashboard link should direct to user dashboard
  Given I am on the oneProsper homepage
  When I follow "user_dashboard"
  Then I should be on the user dashboard

Scenario: Dashboard should show user profile data (name, email)
  Then I should see "Mister Test"
  And I should see "test@email.com"

Scenario: Dashboard should show campaign status
  Then I should see "My Campaigns"
  # rest to be added when campaigns are implemented

Scenario: Dashboard should show list of donations (from the user)
  Then I should see "My Donations"
  # rest to be added when donations are implemented

Scenario: Dashboard should have link to list of farmers page (homepage) as a "Projects Fund" button
  When I follow "Projects to Fund"
  Then I should be on the oneProsper homepage

Scenario: Dashboard should have link to page of farmers that you have been invited to donate to as "Invitation to Fund" button
  When I follow "Invitations to Fund"
  # rest to be added when we add invitation to doante
