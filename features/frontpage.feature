Feature: front page
  As a visitor
  So that I know what website I am on
  I want to see a front page

Background:
  Given I am on the front page

Scenario: have logo
  Then I should see picture of logo

Scenario: link to farmers page
  When I follow "All Projects"
  Then I should be on the projects index page

Scenario: link to login page
  When I follow "Login"
  Then I should be on the login user page

Scenario: Start your campaign button   
  When I follow "Start Your Campaign"
  Then I should be on the login user page

Scenario: link to register
  When I follow "Register"
  Then I should be on the register user page
  
Scenario: have steps of how website works
  Then I should see "How It Works"

Scenario: have picture of farmers 
    #  And I should see picture of farmers
#
Scenario: have link to project index page
  When I follow "Projects"
  Then I should be on the projects index page
