class ChangeProjectEndDate < ActiveRecord::Migration
  def up
    change_column :projects, :end_date, :date
  end

  def down
    change_column :projects, :end_date, :datetime
  end
end
