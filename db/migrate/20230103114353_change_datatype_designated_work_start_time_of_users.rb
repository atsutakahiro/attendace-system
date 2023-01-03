class ChangeDatatypeDesignatedWorkStartTimeOfUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :designated_work_start_time, :datetime
  end
end
