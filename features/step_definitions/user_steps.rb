Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

Given /the following admins exist/ do |admins_table|
  admins_table.hashes.each do |admin|
    Admin.create!(admin)
  end
end

Given /^I am logged in as the test user$/ do
  User.create!({:email=>"test@email.com", :password=>"password", :first_name=>"Mister", :last_name=>"Test"})

  visit path_to('the login user page')
  fill_in('Email', :with => 'test@email.com')
  fill_in('Password', :with => 'password')
  click_button('Sign in')
end

Given /^I register with an email that is already registered$/ do
  fill_in('Email', :with => 'test@email.com')
  fill_in('Password', :with => 'password')
  fill_in('Password confirmation', :with => 'password')
  click_button('Sign up')
end

Given /^I register with an invalid password$/ do
  fill_in('Email', :with => 'test3@email.com')
  fill_in('Password', :with => 'pass')
  fill_in('Password confirmation', :with => 'pass')
  click_button('Sign up')
end

Given /^I register with wrong password confirmation$/ do
  fill_in('Email', :with => 'test3@email.com')
  fill_in('Password', :with => 'password')
  fill_in('Password confirmation', :with => 'pass')
  click_button('Sign up')
end

Given /^I register with a blank password$/ do
  fill_in('Email', :with => 'test3@email.com')
  fill_in('Password', :with => '')
  fill_in('Password confirmation', :with => '')
  click_button('Sign up')
end

Given /^I login with incorrect password$/ do
  fill_in('Email', :with => 'test@email.com')
  fill_in('Password', :with => 'blah')
  click_button('Sign in')
end

Given /^I login with incorrect email$/ do
  fill_in('Email', :with => 'test4@email.com')
  fill_in('Password', :with => 'blah')
  click_button('Sign in')
end

