class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.references :clothing_item, null: false, foreign_key: true
      t.string :buyer_name
      t.string :address
      t.string :delivery_status

      t.timestamps
    end
  end
end
