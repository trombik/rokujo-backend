import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static values = { targetId: String }
  static targets = [ "modal" ]

  connect() {
    this.modal = bootstrap.Modal.getInstance(this.element) || new bootstrap.Modal(this.element);

    this.streamHandler = this.toggleModalOnStreamRender.bind(this);
    this.closeHandler = this.clearModalOnClose.bind(this);


    document.addEventListener('turbo:before-stream-render', this.streamHandler);
    this.element.addEventListener('hide.bs.modal', this.closeHandler);
  }

  disconnect() {
    document.removeEventListener('turbo:before-stream-render', this.streamHandler);
    this.element.removeEventListener('hide.bs.modal', this.closeHandler);
    if (this.modal) this.modal.dispose()
  }

  toggleModalOnStreamRender = (event) => {
    const renderedFrame = event.detail.newStream
    if (renderedFrame.target !== this.targetIdValue) return;

    const isCloseAction = renderedFrame.templateContent.querySelector('[data-close]')?.dataset?.close;
    if (isCloseAction) {
      if (this.modal) { this.modal.hide() }
    } else {
      if (this.modal) { this.modal.show() }
    }
  }

  clearModalOnClose = (event) => {
    const content = this.modalTarget.querySelector(`#${this.targetIdValue}`);
    if (content) content.innerHTML = "";
  }
}
