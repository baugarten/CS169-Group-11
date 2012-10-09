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


Scenario: register an account
  Given I am on the register user page
  When I fill in "Email" with "test@email.com"
  And I fill in "Password" with "password"
  And I fill in "Password confirmation" with "password"
  And I press "Sign up"
  Then I should be on the users home page

Scenario: login to an account
  Given I am on the login user page
  When I fill in "Email" with "test@email.com"
  And I fill in "Password" with "password"
  And I press "Sign in"
  Then I should be on the oneProsper home page

Scenario: login to an admin account
  Given I am on the login admin page
  When I fill in "Email" with "test2@email.com"
  And I fill in "Password" with "password"
  And I press "Sign in"
  Then I should be on the oneProsper home page
