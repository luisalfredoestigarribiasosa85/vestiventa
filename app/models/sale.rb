class Sale < ApplicationRecord
  belongs_to :clothing_item
  belongs_to :user

  # Definir los estados de entrega
  enum :delivery_status, {
    pending: 0,
    in_transit: 1,
    delivered: 2
  }, default: :pending, prefix: true

  # Validaciones
  validates :buyer_name, :address, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :delivery_status, presence: true, inclusion: { in: delivery_statuses.keys.map(&:to_s) }
  validate :clothing_item_must_be_available, on: :create
  validate :clothing_item_must_belong_to_user

  # Callbacks
  before_validation :set_user_from_clothing_item, on: :create
  before_validation :set_price_from_clothing_item, on: :create
  before_validation :set_default_delivery_status, on: :create
  after_create :mark_clothing_item_as_sold

  # Scopes
  scope :recent, -> { order(created_at: :desc) }

  # Método para obtener el estado de entrega formateado
  def delivery_status_name
    I18n.t("sales.delivery_status.#{delivery_status}")
  end

  private

  def set_default_delivery_status
    self.delivery_status = :pending if delivery_status.blank?
  end

  def set_price_from_clothing_item
    self.price ||= clothing_item.price if clothing_item
  end

  # Marca la prenda como vendida al crear la venta
  def mark_clothing_item_as_sold
    clothing_item.update!(sold: true)
  end

  # Valida que la prenda esté disponible para la venta
  def clothing_item_must_be_available
    return unless new_record?  # Solo validar al crear una nueva venta
    return unless clothing_item

    if clothing_item.sold?
      errors.add(:base, I18n.t("activerecord.errors.models.sale.attributes.clothing_item.already_sold"))
    end
  end

  # Valida que la prenda pertenezca al usuario actual
  def clothing_item_must_belong_to_user
    return unless clothing_item

    if clothing_item.user != user
      errors.add(:base, I18n.t("activerecord.errors.models.sale.attributes.clothing_item.not_owner"))
    end
  end

  # Establece el usuario como el dueño de la prenda
  def set_user_from_clothing_item
    self.user ||= clothing_item&.user
  end
end
