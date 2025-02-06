import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    content: String,
  };

  connect() {
    this.originalText = this.element.innerHTML;
  }

  copy() {
    navigator.clipboard.writeText(this.contentValue).then(() => {
      this.element.textContent = "コピーしました！";
      setTimeout(() => {
        this.element.innerHTML = this.originalText;
      }, 2000);
    });
  }
}
