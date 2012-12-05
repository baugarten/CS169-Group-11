Given /^the following projects exist$/ do |projects_table|
  projects_table.hashes.each do |project|
    Project.create(project)
  end
end

