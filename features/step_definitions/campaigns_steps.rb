Given /^campaigns have been created$/ do
  current_user = User.find(1)
  current_user.campaign.create!({
	:name => "Help Farmer1",
	:template => "Hi <name>, please look at this video. <link>",
	:video => Video.create(:video_id=>"http://www.youtube.com/watch?v=oHg5SJYRHA0"),
  :priority => 1,
  :project => Project.find(1),
  :user_id => current_user.id
  })
  
  campaign = Campaign.find(1)
  friend = campaign.campaign_friend.new
  friend.name = "Bob Smith"
  friend.email = "bobsmith@gmail.com"
  friend.email_subject = "hola"
  friend.email_template = "say sth to my fd"
  friend.opened = true
  friend.save

  friend = campaign.campaign_friend.new
  friend.name = "Jack Black"
  friend.email = "jblack@gmail.com"
  friend.opened = false
  friend.email_subject = "hola"
  friend.email_template = "say sth to my fd"
  friend.save

  current_user.campaign.create!({
	:name => "Help Farmer2",
	:template => "Hi <name>, please look at this video. <link>",
	:video => Video.create(:video_id=>"http://www.youtube.com/watch?v=oHg5SJYRHA0"),
  :priority => 1,
  :project => Project.find(2),
  :user_id => current_user.id
  })

  campaign = Campaign.find(2)
  friend = campaign.campaign_friend.new
  friend.name = "John Smith"
  friend.email = "johnsmith@gmail.com"
  friend.email_subject = "hola3"
  friend.email_template = "say sth to my fd3"
  friend.save
end

Given /^another user created a campaign$/ do
  User.create!({:email=>"test22@22email.com", :password=>"password", :first_name=>"FMister", :last_name=>"FTest"})
  current_user = User.find(2)
  current_user.campaign.create!({
	:name => "Help Farmer1",
	:template => "Hi <name>, please look at this video. <link>",
	:video => Video.create(:video_id=>"http://www.youtube.com/watch?v=oHg5SJYRHA0"),
  :priority => 1,
  :project => Project.find(1),
  :user_id => current_user.id
  })

  campaign = Campaign.find(3)
  friend = campaign.campaign_friend.new
  friend.name = "Bob3 Smith3"
  friend.email = "bobsmith3@g3mail.com"
  friend.opened = true
  friend.save
end

When /^(?:|I )want to access the campaign with id "([^"]*)"$/ do |id|
  visit manager_campaign_path(id)
end

When /^(?:|I )try to access the campaign not belong to me$/ do
  visit manager_campaign_path(3)
end

Given /^we are on the template page$/ do
  click_link("Start a new campaign")
  click_link("Farmer1")
  fill_in("Friend", :with => "My Friend <myfriend@bunkmail.com>")
  choose("link")
  fill_in("Video Link", :with => "kjshfklg")
  click_button("Next")
  fill_in("Friend", :with => "Admiral Crunch <friend2@bunkmail.com>")
  choose("link")
  fill_in("Video Link", :with => "kjshfklg")
  click_button("Next")
	click_link("Finished")
end

Given /^we are on the friends page$/ do
  click_link("Start a new campaign")
  click_link("Farmer1")
end

Then /^go directly to template page$/ do
  visit template_campaign_path
end

Then /^We are at the fill in friend's email page$/ do
  visit friends_campaign_path
end

Then /^the manager should show "(.*?)" have been sent the email$/ do |name|
  match = /#{name}.*Confirmed/m =~ page.body
  assert match != nil
end

Then /^the manager should show "(.*?)" have not been sent the email$/ do |name|
  match = /#{name}.*Unconfirmed/m =~ page.body
  assert match != nil
end

Then /^I opened the tracking response link "(.*?)" time$/  do |x|
  visit confirm_watched_campaign_path(:id=>2,:friend=>3)
end

Given /^I sent the email out to my fd already$/ do
  visit track_campaign_path(:id=>2,:friend=>3)
end
