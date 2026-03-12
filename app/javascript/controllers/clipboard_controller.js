import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["source", "icon"]

  connect() {
  }

  copy() {
    const text = this.sourceTarget.innerText || this.sourceTarget.value
    navigator.clipboard.writeText(text).then(() => {
      this.showSuccess()
    })
  }

  showSuccess() {
    const originalClass = this.iconTarget.className
    this.iconTarget.className = "bi bi-check-lg"

    setTimeout(() => {
      this.iconTarget.className = originalClass
    }, 2000)
  }
}
