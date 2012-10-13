Feature: Donor pictures
  As a donor,
  I want to be able to upload a picture of myself,
  So that my contributions aren't completely faceless.

Background: User logged in and on profile page
  # canonical test data: "Mister Test" with email "test@email.com" with no picture
  Given I am logged in as the test user
  And I am on the user dashboard
  
Scenario: Users without pictures should have a default picture
  Then I should see "user_generic.jpg"

Scenario: There should be a "upload profile picture" button on the user dashboard
  Then I should see "Upload profile picture"

Scenario: Uploaded pictures should return to user dashboard with success message
  When I attach the file "valid_profile_picture.jpg" to "profile_picture_file"
  And press "profile_picture_upload"
  Then I should be on the user dashboard
  And I should see "Profile picture uploaded successfully"

Scenario: Uploading an invalid picture should return to user dashboard with an error message
  When I attach the file "invalid_profile_picture.jpg" to "profile_picture_file"
  And press "profile_picture_upload"
  Then I should be on the user dashboard
  And I should see "Error: Uploaded profile picture invalid"
