Feature: Make a donation
  As a user
  So that I can donate money to help the farmer
  I want to see a donation option or button

Background:
  Given the following projects exist
  | farmer      | description | target | current | end_date | completed |
  | Farmer John | Oink!       | 500    | 0       | 1/1/2015 | false     | 
  | Farmer Joe  | Moo!        | 500    | 490      | 1/1/2015 | false    | 
  | Farmer Bob  | Bawk!       | 500    | 500      | 1/1/2015 | true     | 

Scenario: Farmer and donation amount choice should correctly transfer to donation payment page
  When I am on the project details page for "Farmer John"
  And I choose "$5"
  And I press "Donate"
  # farmer to donate to
  Then I should see "Farmer John"
  # donation amount
  And the "donation_readable_amount" field should contain "\$5.00"

Scenario: Email data should transfer from logged-in user
  Given I am logged in as the test user
  When I am on the project details page for "Farmer John"
  And I choose "$5"
  And I press "Donate"
  # email field pre-populated with logged-in user data
  And the "donation_email" field should contain "test@email.com"

Scenario: Attempting to donate to completed project gives an error
  When I am on the project details page for "Farmer Bob"
  And I choose "$5"
  And I press "Donate"
  Then I should be on the projects index page
  Then I should see "this project has already reached its goal"
  
Scenario: Attempting to donate too much
  When I am on the project details page for "Farmer Joe"
  And I choose "$20"
  And I press "Donate"
  Then I should be on the project details page for "Farmer Joe"
  And I should see "There is only $10.00 left to fund for this project; you attempted to donate $20.00"

@javascript
Scenario: Empty custom donation choice should return error
  When I am on the project details page for "Farmer John"
  And I choose "Other"
  And I press "Donate"
  Then I should be on the project details page for "Farmer John"
  Then I should see "Invalid donation amount"
  
@javascript
Scenario: Minimum donation amount of $5.00
  When I am on the project details page for "Farmer John"
  And I choose "Other"
  And I fill in "donation_amount" with "4.99"
  And I press "Donate"
  Then I should be on the project details page for "Farmer John"
  Then I should see "Minimum donation amount is $5.00; you attempted to donate $4.99"

@javascript
Scenario: Donation multiple of $5.00
  When I am on the project details page for "Farmer John"
  And I choose "Other"
  And I fill in "donation_amount" with "19.99"
  And I press "Donate"
  Then I should be on the project details page for "Farmer John"
  Then I should see "Donations must be a multiple of $5.00; you attempted to donate $19.99"
  
@javascript
Scenario: Farmer and custom donation amount choice should correctly transfer to donation payment page
  When I am on the project details page for "Farmer John"
  And I choose "Other"
  And I fill in "donation_amount" with "10"
  And I press "Donate"
  Then I should see "Farmer John"
  And the "donation_readable_amount" field should contain "\$10.00"
 

