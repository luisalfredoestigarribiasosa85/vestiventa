import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "price", "originalPrice"]

  connect() {
    this.syncHint()
  }

  updatePrice() {
    const option = this.hasItemTarget ? this.itemTarget.selectedOptions[0] : null
    const price = option?.dataset.price

    if (price) {
      this.priceTarget.value = price
    }

    this.syncHint()
  }

  syncHint() {
    if (!this.hasOriginalPriceTarget) return

    const option = this.hasItemTarget ? this.itemTarget.selectedOptions[0] : null
    const price = option?.dataset.price

    if (price) {
      const formatted = new Intl.NumberFormat("es-PY").format(Number(price))
      this.originalPriceTarget.textContent = `Precio de la prenda: Gs. ${formatted}`
    } else {
      this.originalPriceTarget.textContent = "Se completa con el precio de la prenda."
    }
  }
}
