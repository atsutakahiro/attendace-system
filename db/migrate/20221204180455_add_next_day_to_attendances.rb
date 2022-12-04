class AddNextDayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :next_day, :boolean, dafault: false
    add_column :attendances, :indicater_request, :string
  end
end
