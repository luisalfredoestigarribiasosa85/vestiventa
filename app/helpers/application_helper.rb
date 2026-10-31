module ApplicationHelper
  COLOR_SWATCHES = {
    "negro" => "#1b1b1f",
    "blanco" => "#f8f7f2",
    "gris" => "#9a9a96",
    "azul" => "#355b9e",
    "celeste" => "#94b8d4",
    "rojo" => "#a32b28",
    "bordo" => "#6a1f33",
    "verde" => "#466b46",
    "oliva" => "#6f7044",
    "beige" => "#d7c7ad",
    "crema" => "#eae0cb",
    "camel" => "#b78b5e",
    "marrón" => "#6b4a35",
    "marron" => "#6b4a35",
    "rosa" => "#d79aa6",
    "amarillo" => "#e3c148",
    "naranja" => "#cf6b32",
    "violeta" => "#6a4b8a",
    "lila" => "#b6a1cf",
    "dorado" => "#b8933f",
    "plateado" => "#b9bcc0"
  }.freeze

  # Guaraníes have no cents: thousands separated by dots.
  def guaranies(amount)
    number_to_currency(
      amount || 0,
      unit: "Gs.",
      precision: 0,
      delimiter: ".",
      separator: ",",
      format: "%u %n"
    )
  end

  def swatch_color(color)
    COLOR_SWATCHES[color.to_s.strip.downcase]
  end

  def size_tag_modifier(size)
    size.to_s.length > 2 ? "size-tag--long" : nil
  end

  def delivery_status_css(sale)
    case sale.delivery_status
    when "pending" then "status--pending"
    when "in_transit" then "status--transit"
    when "delivered" then "status--delivered"
    end
  end

  def delivery_status_label(sale)
    t("sales.delivery_status.#{sale.delivery_status}", default: sale.delivery_status.to_s.humanize)
  end

  def nav_current(controller)
    controller_name == controller ? "page" : nil
  end
end
