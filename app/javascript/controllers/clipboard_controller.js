import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.originalText = this.element.innerHTML;
  }

  copy() {
    const invitationUrl = this.element.getAttribute(
      "data-clipboard-content-value",
    );
    navigator.clipboard.writeText(invitationUrl).then(() => {
      this.element.textContent = "コピーしました！";
      setTimeout(() => {
        this.element.innerHTML = this.originalText;
      }, 2000);
    });
  }
}
