class CreateClothingItems < ActiveRecord::Migration[8.0]
  def change
    create_table :clothing_items do |t|
      t.string :name
      t.string :size
      t.string :color
      t.integer :price
      t.boolean :sold

      t.timestamps
    end
  end
end
