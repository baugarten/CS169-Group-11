describe "User display names" do
  it "should display first and last names" do
    u = User.create!({:email => "a@b.com", :password => "password", :password_confirmation => "password",
                 :first_name => "first", :last_name => "last"})
    u.displayname.should eq "first last"
  end
  it "should display first name" do
    u = User.create!({:email => "b@b.com", :password => "password", :password_confirmation => "password",
                 :first_name => "first"})
    u.displayname.should eq "first"
  end
  it "should display last name" do
    u = User.create!({:email => "c@b.com", :password => "password", :password_confirmation => "password",
                 :last_name => "last"})
    u.displayname.should eq "last"
  end
  it "should at least be funny" do
    u = User.create!({:email => "d@b.com", :password => "password", :password_confirmation => "password"})
    u.displayname.should eq "beats me"
  end
end
