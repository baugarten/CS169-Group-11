class CampaignFriend < ActiveRecord::Base
  attr_accessible :name, :email, :campaign_id, :email_template, :email_subject, :sent_count, :opened, :youtube_id, :video_link
  belongs_to :campaign
  has_many :donation

  include Rails.application.routes.url_helpers
  
  def email_body
    body = email_template
    body.gsub!("<name>", name)
    body.gsub!("<email>", email)
    body.gsub!("<link>", video_campaign_friend_url(self))

    return body
  end
  
  # from http://stackoverflow.com/questions/5909121/converting-a-regular-youtube-link-into-an-embedded-video
  def youtube_id
    video_regexp = [  /^(?:https?:\/\/)?(?:www\.)?youtube\.com(?:\/v\/|\/watch\?v=)([A-Za-z0-9_-]{11})/, 
                      /^(?:https?:\/\/)?(?:www\.)?youtu\.be\/([A-Za-z0-9_-]{11})/,
                      /^(?:https?:\/\/)?(?:www\.)?youtube\.com\/user\/[^\/]+\/?#(?:[^\/]+\/){1,4}([A-Za-z0-9_-]{11})/
                       ]
    video_regexp.each do |m|
      match = m.match(self.video_link)
      return match[1] unless match.nil?
    end
    return nil
  end
  
  def video_link
    return self.campaign.video.link
  end
end
