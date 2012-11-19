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

Given /^campaigns have been created$/ do
  current_user = User.find(1)
  current_user.campaign.create!({
	:name => "Help Farmer1",
	:template => "Hi <name>, please look at this video. <link>",
	:video_link => "http://www.youtube.com/watch?v=oHg5SJYRHA0",
  :priority => 1,
  :project => Project.find(1),
  :user_id => current_user.id
  })

  campaign = Campaign.find(1)
  friend = campaign.campaign_friend.new
  friend.name = "Bob Smith"
  friend.email = "bobsmith@gmail.com"
  friend.opened = true
  friend.save

  friend = campaign.campaign_friend.new
  friend.name = "Jack Black"
  friend.email = "jblack@gmail.com"
  friend.opened = false
  friend.save

  current_user.campaign.create!({
	:name => "Help Farmer2",
	:template => "Hi <name>, please look at this video. <link>",
	:video_link => "http://www.youtube.com/watch?v=oHg5SJYRHA0",
  :priority => 1,
  :project => Project.find(2),
  :user_id => current_user.id
  })

  campaign = Campaign.find(2)
  friend = campaign.campaign_friend.new
  friend.name = "John Smith"
  friend.email = "johnsmith@gmail.com"
  friend.save


end

Then /^the manager should show "(.*?)" have been sent the email$/ do |name|
  match = /#{name}.*Confirmed/m =~ page.body
  assert match != nil
end

Then /^the manager should show "(.*?)" have not been sent the email$/ do |name|
  match = /#{name}.*Unconfirmed/m =~ page.body
  assert match != nil

end


Then /^the manager should show "(.*?)" have donated "(.*?)"$/ do |name, donation_amount|
  text = name + " " + donation_amount
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end


Given /^I am logged in as the test user$/ do
  User.create!({:email=>"test@email.com", :password=>"password", :first_name=>"Mister", :last_name=>"Test"})

  visit path_to('the login user page')
  fill_in('Email', :with => 'test@email.com')
  fill_in('Password', :with => 'password')
  click_button('Sign in')
end

Given /^I am logged in as an admin$/ do
  Admin.create!({:email => "admin@email.com", :password => "password"})

  visit path_to('the login admin page')
  fill_in('Email', :with => 'admin@email.com')
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

Then /^the manager should be on the "(.*)" page$/ do |campaign_name|
  current_path = URI.parse(current_url).path
  id = Campaign.find_by_name(campaign_name)
  assert(current_path.match(/\/(.*)\/manager/))
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


When /^I delete the test user$/ do
  user = User.find_by_email("test@email.com")
  within find("#user#{user.id}") do
    click_button("Delete")
  end
end

When /^I promote the test user to an admin$/ do
  user = User.find_by_email("test@email.com")
  within find("#user#{user.id}") do
    click_button("Make Admin")
  end
end

Then /^the test user should be deleted$/ do
  step "I should not see \"test@email.com\""
end

Then /^the test user should be an admin$/ do
  step "I am on the admin admins page"
  step "I should see \"test@email.com\""
end

When /^I delete the bad admin$/ do
  admin = Admin.find_by_email("test2@email.com")
  within find("#admin#{admin.id}") do
    click_button("Delete")
  end
end

Then /^the bad admin should be deleted$/ do
  step "I am on the admin admins page"
  step "I should not see \"test2@email.com\""
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

When /^I try to donate "(.*)" to "(.*)"$/ do |amount, farmer_name|
  farmer = Project.find_by_farmer(farmer_name)
  post charge_project_path(farmer, :donation=>{:amount=>amount, :email=>""})
end


