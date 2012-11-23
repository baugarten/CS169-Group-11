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

Scenario: email already registered
  Given I am on the register user page
  And I register with an email that is already registered
  Then I should see "Email has already been taken"

Scenario: password is too short
  Given I am on the register user page
  And I register with an invalid password
  Then I should see "Password is too short (minimum is 6 characters)"

Scenario: password is blank
  Given I am on the register user page
  And I register with a blank password
  Then I should see "Password can't be blank"

Scenario: password does not match confirmation
  Given I am on the register user page
  And I register with wrong password confirmation
  Then I should see "Password doesn't match confirmation"
   

