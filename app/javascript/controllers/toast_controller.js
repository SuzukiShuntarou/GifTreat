import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    this.element.querySelectorAll(".toast").forEach((toastElement) => {
      let toast = new bootstrap.Toast(toastElement);
      toast.show();
    });
  }
}
