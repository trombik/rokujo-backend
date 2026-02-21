import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { interval: Number }

  connect() {
    this.url = this.element.src
    this.startRefreshing()
  }

  disconnect() {
    this.stopRefreshing()
  }

  startRefreshing() {
    const ms = this.intervalValue || 5000
    this.timer = setInterval(() => {
      if (this.url) {
        this.element.src = this.url
      }
    }, ms)
  }

  stopRefreshing() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }
}
