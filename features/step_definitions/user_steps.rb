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
  when "select farmer" then assert(current_path.match(/\/campaigns\/(.*)\/farmers/))
  when "enter friends" then assert(current_path.match(/\/campaigns\/(.*)\/friends/))
  when "record video" then assert(current_path.match(/\/campaigns\/(.*)\/video/))
  when "message template" then assert(current_path.match(/\/campaigns\/(.*)\/template/))
  when "send message" then assert(current_path.match(/\/campaigns\/(.*)\/send/))
  end
end

# source http://stackoverflow.com/questions/10740521/how-to-test-mailto-link-in-cucumber
Then /^I should have a mailto link with:$/ do |table| 
  mailto_link = '//a[@href="mailto:' + table.rows_hash['recipient'] + '?subject=' + table.rows_hash['subject'] + '&body=' + table.rows_hash['body'] + ' "]'
  page.should have_xpath(mailto_link)
end