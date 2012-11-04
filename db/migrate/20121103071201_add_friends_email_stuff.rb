class AddFriendsEmailStuff < ActiveRecord::Migration
  def change
    add_column :campaign_friends, :email_template, :text
    add_column :campaign_friends, :email_subject, :text
    
    add_column :campaigns, :email_subject, :text
  end
end
