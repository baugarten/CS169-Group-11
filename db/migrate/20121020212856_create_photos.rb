class CreatePhotos < ActiveRecord::Migration
  def change
	create_table :photos do |t| 
	  t.string :filename
	  t.string :content_type
	  t.binary :binary_data
      
	  t.references :imageable, :polymorphic => true
    end
  end
end
