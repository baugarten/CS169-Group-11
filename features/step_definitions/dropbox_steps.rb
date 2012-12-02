When /^(?:|I )attach the file "([^"]*)" to dropbox for user$/ do |path|
  fill_in("user_image_url_image_url", :with => path)
end

When /^(?:|I )attach the file "([^"]*)" to dropbox for project$/ do |path|
  fill_in("project_photos_attributes_0_url", :with => path)
end


Then /^(?:|I )should see my picture linked from dropbox$/ do

  if page.respond_to? :should
    page.should have_xpath("//img[@src=\"/photo/1\"]")
  else
    assert page.has_xpath?("//img[@src=\"/photo/1\"]")
  end

end
