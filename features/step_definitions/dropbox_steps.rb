When /^(?:|I )attach the file "([^"]*)" to dropbox$/ do |path|
  fill_in("user_image_url", :with => path)
end

Then /^(?:|I )should see my picture linked from dropbox$/
  if page.respond_to? :should
    page.should have_content("https://dl.dropbox.com/s/seh66m5mbjwrt69/rails.png")
  else
    assert page.has_content?("https://dl.dropbox.com/s/seh66m5mbjwrt69/rails.png") 
end
