# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
  30.times do 
    farmer = (0..20).map{ ('a'..'z').to_a[rand(26)] }.join
    description =  (0...100).map{ ('a'..'z').to_a[rand(26)] }.join
    target = 300 + rand(400)
    Project.create(
      :farmer => farmer,
      :description => description,
      :target => target,
      :ending => true,
      :completed => false,
      :priority => 1)
  end
if not Project.first
  Project.create(
    :farmer => "Farmer3",
    :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sed lorem massa. Proin posuere convallis erat et imperdiet. Curabitur sit amet metus quis velit euismod interdum. Duis tincidunt libero eget lorem congue et hendrerit velit viverra. In hac habitasse platea dictumst. Sed commodo posuere.",
    :target => 600,
    :current => 250,
    :end_date => Time.utc(2013, 01, 1),
    :ending => false,
    :completed => false,
    :priority => 1)
  Project.create(
    :farmer => "Farmer2",
    :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce mollis, diam sit amet aliquam fermentum, tellus odio vulputate augue, sed blandit massa ligula in nisi. Praesent dictum rhoncus lectus, sit amet mollis sem interdum sit amet. Nunc tincidunt mollis lectus, vitae pellentesque lorem nullam.",
    :target => 500,
    :current => 100,
    :end_date => Time.utc(2013, 01, 31),
    :ending => false,
    :completed => false,
    :priority => 1)
  Project.create(
    :farmer => "Farmer1",
    :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec quis arcu velit, sit amet elementum orci. Nulla quis faucibus odio. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Suspendisse convallis massa ut felis sollicitudin vel pretium metus laoreet amet",
    :target => 750,
    :end_date => Time.utc(2013, 01, 20),
    :ending => false,
    :completed => false,
    :priority => 1)
end

if not Admin.first
  Admin.create(
    :email => "baugarten@gmail.com",
    :password => "password",
  )
  Admin.create(
    :email => "raju@oneprosper.org",
    :password => "password",
  )
  Admin.create(
    :email => "gsi@cs169.com",
    :password => "railsonrails",
  )
  Admin.create(
    :email => "lsimmonds@green-living.ca",
    :password => "password",
  )
end

if not User.first
  User.create(
    :email => "gsi@cs169.com",
    :password => "railsonrails",
  )
  User.create!(email: "test@test.com", 
    first_name: "test", last_name: "test",
    :password=>"password", :password_confirmation=>"password")
  User.create(
    :email => "lsimmonds@green-living.ca",
    :password => "password",
    :first_name => "Laurie",
    :last_name => "Simmonds"
  )
end

if not Update.first
  Update.create(:title=>"Happy Easter Holiday", :content =>"11111")
  Update.create(:title=>"Added Farmer John", :content =>"11111")
  Update.create(:title=>"Donation Start", :content =>"11111")
  Update.create(:title=>"Happy ThanksGiving", :content =>"11111")
  Update.create(:title=>"Happy Christmas", :content =>"11111")
  Update.create(:title=>"Happy New years", :content =>"11111")
end
