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
  User.create!({:email=>"test@email.com", :password=>"password"})

  visit path_to('the login user page')
  fill_in('Email', :with => 'test@email.com')
  fill_in('Password', :with => 'password')
  click_button('Sign in')
end
