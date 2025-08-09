class AddPriceToSales < ActiveRecord::Migration[8.0]
  # Clase temporal para evitar problemas con el modelo Sale durante la migración
  class TempSale < ApplicationRecord
    self.table_name = 'sales'
    belongs_to :clothing_item, class_name: 'ClothingItem', optional: true
  end

  def change
    # Agregar la columna price como decimal con precisión 10,2 y valor predeterminado 0
    add_column :sales, :price, :decimal, precision: 10, scale: 2, default: 0.0, null: false
    
    # Actualizar registros existentes con un precio predeterminado basado en la prenda asociada
    reversible do |dir|
      dir.up do
        # Para cada venta sin precio, establecer el precio de la prenda asociada
        TempSale.reset_column_information
        TempSale.includes(:clothing_item).find_each do |sale|
          if sale.price.zero? && sale.clothing_item
            execute "UPDATE sales SET price = #{sale.clothing_item.price} WHERE id = #{sale.id}"
          end
        end
      end
    end
  end
end
