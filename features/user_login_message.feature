Feature: Register a user account
  As a conscientious citizen
  So that I can receive updates from my donations
  I want to be able to register and log into a user account

Background: accounts active
  Given the following users exist:
  | email          | password | password_confirmation |
  | test@email.com | password | password              |
  Given the following admins exist:
  | email           | password | password_confirmation |
  | test2@email.com | password | password              |

Scenario: login with incorrect password
  Given I am on the login user page
  And I login with incorrect password 
  Then I should see "Invalid email or password"

Scenario: login with incorrect email
  Given I am on the login user page
  And I login with incorrect email 
  Then I should see "Invalid email or password"




