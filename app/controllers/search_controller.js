import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: Number }
  timeout = null

  update(event) {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      this.element.form.requestSubmit()
    }, this.delayValue || 300)   // delay typing (300ms)
  }
}
