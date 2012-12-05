class CampaignFriend < ActiveRecord::Base
  has_one :video, :as => :recordable

  attr_accessible :name, :email, :campaign_id, :sent_count, :opened, :video
  belongs_to :campaign

  
  def email_body(request)
    body = email_template
    body.gsub!("<name>", name)
    body.gsub!("<email>", email)
    body.gsub!("<link>", confirm_link(request))

    return body
  end

  def confirm_link(request)
    %Q{#{request.protocol}#{request.host_with_port}/campaigns/#{campaign_id}/confirm_watched?friend=#{id}}
  end

  def email_template
    campaign.template
  end

  def email_subject
    campaign.email_subject
  end
end
