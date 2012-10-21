# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Project.create(
  :farmer => "Farmer3",
  :description => "He's a little quiet. He refuses to speak.",
  :target => 600,
  :current => 250,
  :end_date => Time.utc(2013, 01, 1),
  :ending => false,
  :completed => false,
  :priority => 1)
Project.create(
  :farmer => "Farmer2",
  :description => "Farmer2 enjoys long walks on the beach and donations. Especially donations. He doesn't even really walk on the beach ever",
  :target => 500,
  :current => 100,
  :end_date => Time.utc(2013, 01, 31),
  :ending => false,
  :completed => false,
  :priority => 1)
Project.create(
  :farmer => "Farmer1",
  :description => "Farmer1 enjoys drinking tea and really just wants some more crops. He needs water. He's thirsty.",
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
