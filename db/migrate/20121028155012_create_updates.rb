class CreateUpdates < ActiveRecord::Migration
  def up
    create_table 'updates' do |t|
      t.string 'title'
      t.text 'content'
      
      t.timestamps
    end
  end

  def down
    drop_table 'updates'
  end
end
