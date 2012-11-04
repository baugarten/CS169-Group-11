Then /^(?:|I )should see picture of ([^"]*)$/ do |picture|
  page.should have_xpath("//img[@src='/assets/#{picture}.png']")
end


