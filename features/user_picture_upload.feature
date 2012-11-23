Feature: Donor pictures
  As a donor,
  I want to be able to upload a picture of myself,
  So that my contributions aren't completely faceless.

Background: User logged in and on profile page
  # canonical test data: "Mister Test" with email "test@email.com" with no picture
  Given I am logged in as the test user
  And I am on the user dashboard
  
Scenario: Users without pictures should have a default picture
  Then I should see "No picture available"

Scenario: Uploaded pictures should return to user dashboard with success message
  When I follow "Edit Profile"
  And I attach the file "features/assets/test_picture.png" to "user_image_file"
  And press "Save"
  Then I should be on the user dashboard
  And I should see "Picture uploaded successfully"
  And I should not see "No picture available"
