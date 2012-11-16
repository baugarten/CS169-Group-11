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

Given /^farmers have been created$/ do
  Project.create!({
	:farmer => "Farmer1",
	:description => "First farmer! 50char 50char 50char 50char 50char 50char 50char 50char",
	:target => 500,
  :ending => true,
	:current => 0,
  })
  Project.create!({
	:farmer => "Farmer2",
	:description => "I farm turnips and pie 50char 50char 50char 50char 50char 50char",
	:target => 500,
  :ending => true,
	:current => 0,
  })
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

Then /^the campaign should be on the "(.*)" page$/ do |page_name|
  current_path = URI.parse(current_url).path
  case page_name
  when "select farmer" then assert(current_path.match(/\/campaigns\/(.*)\/farmers/))
  when "enter friends" then assert(current_path.match(/\/campaigns\/(.*)\/friends/))
  when "record video" then assert(current_path.match(/\/campaigns\/(.*)\/video/))
  when "message template" then assert(current_path.match(/\/campaigns\/(.*)\/template/))
  when "send message" then assert(current_path.match(/\/campaigns\/(.*)\/send/))
  end
end

When /^I fill in phony credentials$/ do
  fill_in('Email', :with => "fake@email.com")
  fill_in('Password', :with => "APSJDOPajkdlSANKJDHBASKDAIWRJAUEH<KAFJNBDAF<K")
  click_button('Sign in')
end

When /^I fill in correct payment information$/ do
  click_button('Donate')
  fill_in('paymentNumber', :with=>"4242424242424242")
  fill_in('paymentExpiryMonth', :with=>"1")
  fill_in('paymentExpiryYear', :with=>"25")
  fill_in('paymentName', :with=>"John Doe")
  fill_in('paymentCVC', :with=>"123")
end

When /^I fill in invalid payment information$/ do
  click_button('Donate')
  fill_in('paymentNumber', :with=>"4000000000000002")
  fill_in('paymentExpiryMonth', :with=>"1")
  fill_in('paymentExpiryYear', :with=>"25")
  fill_in('paymentName', :with=>"John Doe")
  fill_in('paymentCVC', :with=>"123")
end
