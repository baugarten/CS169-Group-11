class MakeCampaignReferences < ActiveRecord::Migration
  def change
    add_column :users, :campaign_id, :integer
    add_index :users, :campaign_id

    add_column :campaigns, :user_id, :integer
    add_index :campaigns, :user_id    

    add_column :campaigns, :campaign_friends_id, :integer
    add_index :campaigns, :campaign_friends_id    
    
    add_column :campaign_friends, :campaign_id, :integer
    add_index :campaign_friends, :campaign_id 
    
    add_column :campaigns, :campaign_project_id, :integer
    add_index :campaigns, :campaign_project_id    
    
    add_column :projects, :campaign_id, :integer
    add_index :projects, :campaign_id
  end
end
