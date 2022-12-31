class RemoveCardIdFromUserss < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :card_id, :string
  end
end
