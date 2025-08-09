class ClothingItem < ApplicationRecord
  belongs_to :user
  has_one :sale, dependent: :destroy

  validates :name, :size, :color, :price, :owner_name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  
  # Scope para obtener prendas disponibles para la venta
  # (que no estén ya vendidas)
  scope :available_for_sale, -> { where(sold: false) }
  
  # Método para marcar una prenda como vendida
  def mark_as_sold!
    update!(sold: true)
  end
  
  # Método para verificar si una prenda está disponible para la venta
  def available_for_sale?
    !sold?
  end
end
