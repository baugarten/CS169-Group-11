Feature: Donor pictures
  As a donor,
  I want to be able to upload a picture of myself,
  So that my contributions aren't completely faceless.

Background: User logged in and on profile page
  Given I am logged in as a test user
  And I am on the users homepage
  
Scenario: Users without pictures should have a default picture

Scenario: There should be a "upload new picture" button on the user dashboard

Scenario: Uploaded pictures should take effect

Scenario: Uploaded pictures should return to user dashboard with success message

Scenario: Uploading an invalid picture should return to user dashboard with an error message

Scenario: Uploading an invalid picture should not replace the current picture
