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
	:current => 0,
  })
  Project.create!({
	:farmer => "Farmer2",
	:description => "I farm turnips and pie 50char 50char 50char 50char 50char 50char",
	:target => 500,
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

Then /^the campaign should be on the "(.*)" page$/ do |page_name|
  current_path = URI.parse(current_url).path
  case page_name
  when "select farmer" then assert(current_path.match(/\/dashboard\/campaigns\/(.*)\/farmers/))
  when "enter friends" then assert(current_path.match(/\/dashboard\/campaigns\/(.*)\/friends/))
  when "record video" then assert(current_path.match(/\/dashboard\/campaigns\/(.*)\/video/))
  when "message template" then assert(current_path.match(/\/dashboard\/campaigns\/(.*)\/message/))
  when "send message" then assert(current_path.match(/\/dashboard\/campaigns\/(.*)\/send/))
  end
end