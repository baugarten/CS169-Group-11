class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :farmer
      t.text :description
      t.integer :target
      t.decimal :current
      t.timestamp :end_date
      t.boolean :ending
      t.boolean :completed
      t.integer :priority

      t.timestamps
    end
  end
end
