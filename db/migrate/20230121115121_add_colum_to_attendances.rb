class AddColumToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :indicater_check_edit_anser, :string
    add_column :attendances, :month_approval, :date
    add_column :attendances, :indicater_check_month, :string
    add_column :attendances, :indicater_reply_month, :integer
    add_column :attendances, :change_month, :boolean, default: false
    add_column :attendances, :indicater_check_month_anser, :string
    add_column :attendances, :one_month_request_superior, :string
    add_column :attendances, :one_month_request_status, :string
    add_column :attendances, :one_month_approval_status, :string
    add_column :attendances, :one_month_approval_check, :boolean, default: false
    add_column :attendances, :business_process_content, :string
    add_column :attendances, :edit_started_at, :datetime
    add_column :attendances, :edit_finished_at, :datetime
    add_column :attendances, :next_day, :boolean
    add_column :attendances, :indicater_request, :string
    add_column :attendances, :month_change, :boolean, default: false
    add_column :attendances, :indicater_select, :string
  end
end
