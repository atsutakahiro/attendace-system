class AddBasicInfo4ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :basic_work_time, :datetime
    add_column :users, :uid, :string
    add_column :users, :employee_number, :string
  end
end
