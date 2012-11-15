class Donation < ActiveRecord::Base
  attr_accessible :email, :amount, :project_id, :user_id, :stripe_token
  
  belongs_to :project
  belongs_to :user
end
