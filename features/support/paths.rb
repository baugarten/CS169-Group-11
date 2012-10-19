# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the (oneProsper )?(home|front)\s?page$/ then '/'
    when /^the register user page$/ then '/users/sign_up'
    when /^the users home page$/ then '/users'
    when /^the login user page$/ then '/users/sign_in'
    when /^the login admin page$/ then '/admins/sign_in'
    when /^the create project page$/ then '/projects/new'
    when /^the project index page$/ then '/projects'
    when /^the project details page for "(.*)"$/ 
      project_path(Project.find_by_farmer $1)
    

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
