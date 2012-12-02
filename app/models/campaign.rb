class Campaign < ActiveRecord::Base
  attr_accessible :name, :template, :priority, :video, :user_id, :user, :campaign_friend_id, :project_id, :project, :readable_donated
  after_initialize :init
  
  has_many :campaign_friend, :dependent => :destroy
  has_one :project
  has_one :video, :as => :recordable
  belongs_to :user

  def update_donated
    total = 0
    self.campaign_friend.each do |friend|
      friend.donation.each do |donation|
        total += donation.amount
      end
    end
    
    self.donated = total
    self.save!
  end

  def readable_donated()
    donation_amount = self.donated
    dollars = donation_amount / 100
    cents = donation_amount % 100
    if (cents < 10)
      cents = "0" + String(cents)
    end
    return "$#{dollars}.#{cents}"
  end
  
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
  
  def video_link
    return video.link
  end
end
