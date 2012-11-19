require 'spec_helper'

describe ApplicationController, :type => :controller do
  before(:all) do
    50.times do 
      farmer = (0..20).map{ ('a'..'z').to_a[rand(26)] }.join
      description =  (0...100).map{ ('a'..'z').to_a[rand(26)] }.join
      target = 300 + rand(400)
      Project.create(
        :farmer => farmer,
        :description => description,
        :target => target,
        :ending => true,
        :completed => false,
      )
    end 
  end
  describe 'Should return top 12 farmers' do
    it "should return 12 farmers" do
      get :frontpage
      assigns(:projects).should have(12).items
    end
    it "should get page 2" do
      get :frontpage, :page => 2
      assigns(:projects).should have(12).items
    end
    it "should have a partial last page" do
      get :frontpage, :page => 5
      assigns(:projects).should have(2).items
    end

    it "should return a count of 50" do
      get :frontpage
      assigns(:count).should eq 50
    end

  end
end
