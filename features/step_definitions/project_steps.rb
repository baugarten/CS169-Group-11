Given /^the following projects exist$/ do |projects_table|
  projects_table.hashes.each do |project|
    Project.create(project)
  end
end

Then /^I should be able to record a video$/ do
  pending
end

Then /^I should be able to add a picture$/ do
  pending
end

Then /^I should be able to delete a video$/ do
  pending
end

Then /^I should be able to delete a picture$/ do
  pending
end
