class CampaignFriend < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  attr_accessible :name, :email, :campaign_id, :email_template, :email_subject, :sent_count, :opened, :youtube_id, :video
  belongs_to :campaign
  has_one :video, :as => :recordable
  has_many :donations
  
  def email_body
    body = email_template
    body.gsub!("<name>", name)
    body.gsub!("<email>", email)
    body.gsub!("<link>", video_campaign_friend_url(self))

    return body
  end
  
  def youtube_id
    return video.video_id
  end
  
  def video_link
    return video.link
  end
end
