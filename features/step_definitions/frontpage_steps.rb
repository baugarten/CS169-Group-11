And /^(?:|I )should see picture of "([^"]*)"$/ do |picture|
  if page.respond_to? :should
    page.should have_selector("img[src$='#{picture}']")
  else
    assert page.has_selector?("img[src$='#{picture}']")
  end
end


