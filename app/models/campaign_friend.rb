class CampaignFriend < ActiveRecord::Base
  attr_accessible :name, :email, :campaign_id, :email_template, :email_subject, :sent_count, :opened, :youtube_id, :video_link
  belongs_to :campaign
  has_many :donations

  include Rails.application.routes.url_helpers
  
  def email_body
    body = email_template
    body.gsub!("<name>", name)
    body.gsub!("<email>", email)
    body.gsub!("<link>", video_campaign_friend_url(self))

    return body
  end
  
  def youtube_id
    return self.campaign.video.video_id
  end
  
  def video_link
    return self.campaign.video.link
  end
end
