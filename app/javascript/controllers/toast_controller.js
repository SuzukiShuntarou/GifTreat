import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    const toastElement = this.element.querySelector(".toast");
    const toast = new bootstrap.Toast(toastElement);
    toast.show();
  }
}
