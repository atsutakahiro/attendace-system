class RenameaffiliationColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :affiliation, :affiliation
  end
end
