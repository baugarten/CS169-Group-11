class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :nickname, :campaign_id
  
  # Photo support
  has_one :photo, :as => :imageable, :dependent => :destroy
  has_many :campaign, :dependent => :destroy

  def displayname
    if self.first_name.blank? and self.last_name.blank?
      return "beats me"
    elsif self.last_name.blank?
      return self.first_name
    elsif self.first_name.blank?
      return self.last_name
    else
      return %Q{#{self.first_name} #{self.last_name}}
    end
  end
end
