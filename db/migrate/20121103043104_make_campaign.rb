class MakeCampaign < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.text :template
      t.string :video_link
      t.integer :priority
    end
    create_table :campaign_friends do |t|
      t.string :email
      t.string :name
    end
  end
end
