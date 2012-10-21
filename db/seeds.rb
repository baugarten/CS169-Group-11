# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
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
Admin.create(
  :email => "baugarten@gmail.com",
  :password => "password",
)
Admin.create(
  :email => "raju@oneprosper.org",
  :password => "password",
)

User.create!(email: "test@test.com", 
	first_name: "test", last_name: "test",
	:password=>"password", :password_confirmation=>"password")
