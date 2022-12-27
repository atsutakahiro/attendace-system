class CreateBases < ActiveRecord::Migration[5.1]
  def change
    create_table :bases do |t|
      t.integer :base_num
      t.string :base_name
      t.string :kinds

      t.timestamps
    end
  end
end
