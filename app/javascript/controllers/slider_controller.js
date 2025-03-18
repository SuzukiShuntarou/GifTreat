import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="slider"
export default class extends Controller {
  connect() {
    this.updateButtons = document.getElementById("update_buttons");
  }

  inputChange() {
    this.updateHiddenInput();
    this.showUpdateButtons();
  }

  updateHiddenInput() {
    const hiddenInputProgress = document.getElementById(
      "hidden_input_progress",
    );
    hiddenInputProgress.value = this.element.value;
  }

  showUpdateButtons() {
    this.updateButtons.style.display = "flex";
  }
}
