class Admin < ActiveRecord::Base
  devise :database_authenticatable, :timeoutable

  attr_accessible :email, :password, :password_confirmation, :encrypted_password
  # attr_accessible :title, :body
end
