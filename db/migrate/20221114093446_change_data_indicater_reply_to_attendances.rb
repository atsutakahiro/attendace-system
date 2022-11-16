class ChangeDataIndicaterReplyToAttendances < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :indicater_reply, :string
  end
end
