Given /^I create a new update$/ do
  fill_in('Title', :with => 'Hello world Aritcle One')
  fill_in('Content', :with => 'testing content')
  click_button('Submit')
end

When /^I edited successfully$/ do
  fill_in('Title', :with => 'Eidted testing')
  fill_in('Content', :with => 'Edited testing content')
  click_button('Submit')
end

When /^I confirmed the delete action$/ do
  click_button('Delete')
  page.driver.browser.switch_to.alert.accept
end

When /^I submit the update with empty title or content$/ do
  fill_in('Title', :with => '')
  fill_in('Content', :with => '')
  click_button('Submit')
end
