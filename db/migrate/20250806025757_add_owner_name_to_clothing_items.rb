class AddOwnerNameToClothingItems < ActiveRecord::Migration[8.0]
  def change
    add_column :clothing_items, :owner_name, :string
  end
end
