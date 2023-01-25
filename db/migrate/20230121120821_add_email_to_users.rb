class AddEmailToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :affiliation, :string
    add_column :users, :basic_time, :datetime, default: "2022-10-20 23:00:00"
    add_column :users, :work_time, :datetime, default: "2022-10-20 22:30:00"
    add_column :users, :designated_work_end_time, :datetime, default: "2022-10-21 09:00:00"
    add_column :users, :basic_work_time, :datetime
    add_column :users, :uid, :string
    add_column :users, :employee_number, :string
    add_column :users, :designated_work_start_time, :datetime, default: Time.current.change(hour: 9, min: 0, sec: 0)
    add_column :users, :superior, :boolean, default: false
    add_column :users, :number, :integer
  end
end
