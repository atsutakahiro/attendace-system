class AddBaseColumnToBases < ActiveRecord::Migration[5.1]
  def change
    add_column :bases, :base_name, :string
    add_column :bases, :kinds, :string
  end
end
