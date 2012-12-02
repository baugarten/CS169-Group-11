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
	:current => 0
  })
  Project.create!({
	:farmer => "Farmer2",
	:description => "I farm turnips and pie 50char 50char 50char 50char 50char 50char",
	:target => 600,
  :ending => true,
	:current => 0
  })
end

When /^I try to donate "(.*)" to "(.*)"$/ do |amount, farmer_name|
  farmer = Project.find_by_farmer(farmer_name)
  post charge_project_path(farmer, :donation=>{:amount=>amount, :email=>""})
end

Given /^test donations exist$/ do
  user = User.create!({
    :email=>"test@email.com",
    :password=>"password",
    :first_name=>"Mister",
    :last_name=>"Test"
  })
  
  project = Project.create!({
    :farmer => "Farmah1",
    :description => "First pharma! 50char 50char 50char 50char 50char 50char 50char 50char",
    :target => 500,
    :ending => true,
    :current => 0
  })
  
  campaign = Campaign.create!({
    :name => "Help Farmer1",
    :template => "Hi <name>, please look at this video. <link>",
    :project => project,
    :user => user
  })

  friend1 = campaign.campaign_friend.create!({
    :video => Video.create!({:video_id=>"oHg5SJYRHA0"}),
    :name => "Peter Griffin",
    :email => "prez@petoria.gov"
  })
  friend2 = campaign.campaign_friend.create!({
    :video => Video.create!({:video_id=>"oHg5SJYRHA0"}),
    :name => "Jack Sparrow",
    :email => "jsparrow@rms.titanic.davyjones-locker.cx"
  })

  donation = Donation.create!({
    :email => "prez@petoria.gov",
    :readable_amount => "$50",
    :project => project,
    :campaign_friend => friend1
  })
  donation = Donation.create!({
    :email => "jsparrow@rms.titanic.davyjones-locker.cx",
    :readable_amount => "$5",
    :project => project,
    :campaign_friend => friend2
  })
  
  campaign.update_donated()
end

Given /^I am logged in as the test donations user$/ do
  # Login user
  visit path_to('the login user page')
  fill_in('Email', :with => 'test@email.com')
  fill_in('Password', :with => 'password')
  click_button('Sign in')
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
  when "select farmer" then visit campaign_farmers_path
  when "enter friends" then assert(current_path.match(/\/campaign\/friends/))
  when "record video" then assert(current_path.match(/\/campaign\/video/))
  when "message template" then assert(current_path.match(/\/campaign\/template/))
  when "send message" then assert(current_path.match(/\/campaign\/manger/))
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
