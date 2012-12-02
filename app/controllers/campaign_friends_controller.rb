class CampaignFriendsController < ApplicationController
  def video
    @campaign_friend = CampaignFriend.find(params[:id])
    
    @donation = Donation.new({
      :campaign_friend => @campaign_friend,
      :email => @campaign_friend.email
      })
    
    @campaign_friend.opened = @campaign_friend.opened + 1
    @campaign_friend.save!
  end
end
