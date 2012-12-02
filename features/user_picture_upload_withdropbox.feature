Feature: Donor pictures with dropbox
  As a donor,
  I want to be able to upload a picture of myself to dropbox,
  So that my contributions aren't completely faceless.

Background: User logged in and on profile page
  # canonical test data: "Mister Test" with email "test@email.com" with no picture
  Given I am logged in as the test user
  And I am on the user dashboard

Scenario: Uploaded pictures should return to user dashboard with success message
  When I follow "Edit Profile"
  And I attach the file "https://dl.dropbox.com/s/seh66m5mbjwrt69/rails.png" to dropbox
  And press "Save"
  Then I should be on the user dashboard
  And I should see "Picture URL saved"
  And I should not see "No picture available"
  
  And I am on the user dashboard
  Then I should see my picture linked from dropbox
