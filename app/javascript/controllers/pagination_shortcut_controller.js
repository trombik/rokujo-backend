import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pagination-shortcut"
export default class extends Controller {
  connect() {
    document.addEventListener("keydown", this.handleKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown)
  }

  handleKeydown = (event) => {
    if (["INPUT", "TEXTAREA"].includes(event.target.tagName)) return

    if (event.key === "n") {
      const nextLink = this.element.querySelector(".page-item.next a[href]")
      if (nextLink) { nextLink.click() }
    } else if (event.key === "p") {
      const prevLink = this.element.querySelector(".page-item.previous a[href]")
      if (prevLink) { prevLink.click() }
    }
  }
}

