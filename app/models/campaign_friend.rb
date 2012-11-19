class CampaignFriend < ActiveRecord::Base
  attr_accessible :name, :email, :campaign_id, :email_template, :email_subject, :sent_count, :opened, :confirm_link
  belongs_to :campaign
  
  def email_body
    body = email_template
    body.gsub!("<name>", name)
    body.gsub!("<email>", email)
    body.gsub!("<link>", confirm_link)

    return body
  end
end
