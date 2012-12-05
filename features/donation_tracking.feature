Feature: Make a donation
  As a campaigner
  So that I can see how effective my campaigns are,
  I want to be able to track the amount of donations from each campaign.

Background:
  Given test donations exist

Scenario: Farmer and donation amount choice should correctly transfer to donation payment page
  When I am on the campaign friend video page for "Peter Griffin"
  And I choose "$10"
  And I press "Donate"
  # farmer to donate to
  Then I should see "Farmah1"
  And the "donation_readable_amount" field should contain "\$10.00"
  And the "donation_email" field should contain "prez@petoria.gov"

Scenario: Dashboard should track total donations
  Given I am logged in as the test donations user
  When I am on the user dashboard
  # correct aggregrate donated amount on dashboard
  Then I should see "$55.00"
  When I am on the campaign details page for "Help Farmer1"
  Then I should see "Campaign donated $55.00 so far"

Scenario: Dashboard should track who has opened the email
  Given I am logged in as the test donations user
  When I am on the campaign details page for "Help Farmer1"
  Then I should not see "Confirmed"
  And I should see "Unconfirmed"
  # visit the page to set the viewed counter for one friend
  When I am on the campaign friend video page for "Peter Griffin"
  When I am on the campaign details page for "Help Farmer1"
  Then I should see "Confirmed"
  And I should see "Unconfirmed"  
  # visit page for other friend
  When I am on the campaign friend video page for "Jack Sparrow"
  When I am on the campaign details page for "Help Farmer1"
  Then I should see "Confirmed"
  And I should not see "Unconfirmed"
