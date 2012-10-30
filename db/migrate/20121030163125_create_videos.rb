class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :video_id
      
      t.references :recordable, :polymorphic => true
      t.timestamps
    end
  end
end
