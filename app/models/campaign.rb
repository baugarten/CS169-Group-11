class Campaign < ActiveRecord::Base
  attr_accessible :name, :template, :video_link, :priority, :user_id, :campaign_friend_id, :project_id
  after_initialize :init

  has_many :campaign_friend, :dependent => :destroy
  has_one :project
  belongs_to :user
  
  def email_list
    list = ""
    campaign_friend.each do |friend|
      if not list.empty?
        list += ", "
      end
      list += "#{friend.name} <#{friend.email}>"
    end
    return list
  end
  
  def init
    self.priority = 0
  end
end
