class AddFriendsSentCountandOpenedMailColumn < ActiveRecord::Migration
  def change
    add_column :campaign_friends, :sent_count, :integer, :default=>'0'
    add_column :campaign_friends, :opened, :integer, :default=>'0'
    add_column :campaign_friends, :confirm_link, :string, :default=>'No LINK'
  end
end
