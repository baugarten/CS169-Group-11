class CreateUserNames < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string, :default => ""
	add_column :users, :last_name, :string, :default => ""
  end

  def down
    remove_column :users, :first_name
	remove_column :users, :last_name
  end
end
