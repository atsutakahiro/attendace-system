class AddColumsToAttendances < ActiveRecord::Migration[5.1]
  def change
     # 1ヶ月の勤怠申請・承認
    add_column :attendances, :one_month_request_superior, :string
    add_column :attendances, :one_month_request_status, :string
    add_column :attendances, :one_month_approval_status, :string
    add_column :attendances, :one_month_approval_check, :boolean, default: false
  end
end
