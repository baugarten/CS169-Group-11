class Admin < ActiveRecord::Base
  devise :database_authenticatable, :timeoutable

  attr_accessible :email, :password, :password_confirmation
  # attr_accessible :title, :body
end
