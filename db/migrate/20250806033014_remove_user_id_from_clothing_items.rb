class RemoveUserIdFromClothingItems < ActiveRecord::Migration[8.0]
  def change
    remove_reference :clothing_items, :user, null: false, foreign_key: true
  end
end
