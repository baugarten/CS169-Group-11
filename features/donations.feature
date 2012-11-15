Feature: Make a donation
  As a user
  So that I can donate money to help the farmer
  I want to see a donation option or button

Background:
  Given the following projects exist
  | farmer      | description | target | current | end_date | ending |
  | Farmer John | Oink!       | 500    | 0      | 1/1/2015 | true   | 

@javascript
Scenario: Make a donation
  When I am on the project details page for "Farmer John"
  Then I should see "$50 donated"
  And I check "$5"
  And I press "Donate"
  # farmer to donate to
  And I should see "Farmer John"
  # donation amount
  And I should see "$5.00"
  # optional field, not checked - but makes sure textbox is there when no user logged in
  And I fill in "Email" with "anon@anon.com"
  And I fill in correct payment information
  And I press "Pay $5.00"
  Then I should see "Thank you"
  When I am on the project details page for "Farmer John"
  Then I should see "$55 donated"

@javascript
Scenario: Make a custom-amount
  When I am on the project details page for "Farmer John"
  Then I should see "$0 donated"
  And I check "Custom amount"
  And I fill in "Custom amount" with "6"
  And I press "Donate"
  And I should see "Farmer John"
  And I should see "$6.00"
  And I fill in "Email" with "anon@anon.com"
  And I fill in correct payment information
  And I press "Pay $6.00"
  Then I should see "Thank you"
  When I am on the project details page for "Farmer John"
  Then I should see "$6 donated"
  
@javascript
Scenario: Attempt to donate using invalid credit card information
  When I am on the project details page for "Farmer John"
  Then I should see "$0 donated"
  And I check "$5"
  And I press "Donate"
  And I fill in invalid payment information
  And I press "Pay $5.00"
  Then I should not see "Thank you"
  When I am on the project details page for "Farmer John"
  Then I should see "$0 donated"

@javascript
Scenario: Make a donation from a logged-in user
  Given I am logged in as the test user
  When I am on the project details page for "Farmer John"
  Then I should see "$0 donated"
  And I check "$5"
  And I press "Donate"
  # email field pre-populated with logged-in user data
  Then I should see "test@email.com"
  When I fill in correct payment information
  And I press "Pay $5.00"
  When I am on the user dashboard
  Then I should see "$5 donated to Farmer John"