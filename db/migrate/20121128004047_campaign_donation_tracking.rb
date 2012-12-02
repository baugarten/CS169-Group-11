class CampaignDonationTracking < ActiveRecord::Migration
  def change
    add_column :campaign_friends, :donation_id, :integer
    add_index :campaign_friends, :donation_id

    add_column :donations, :campaign_friend_id, :integer
    add_index :donations, :campaign_friend_id
    
    add_column :campaigns, :donated, :integer, :default => 0
    
  end
end
