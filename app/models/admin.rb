class Admin < ActiveRecord::Base
  devise :database_authenticatable, :timeoutable
  # attr_accessible :title, :body
end
