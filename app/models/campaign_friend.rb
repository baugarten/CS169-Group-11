class CampaignFriend < ActiveRecord::Base
  has_one :video, :as => :recordable

  attr_accessible :name, :email, :campaign_id, :email_template, :email_subject, :sent_count, :opened, :confirm_link, :video
  belongs_to :campaign

  
  def email_body
    body = email_template
    body.gsub!("<name>", name)
    body.gsub!("<email>", email)
    body.gsub!("<link>", confirm_link)

    return body
  end
end
