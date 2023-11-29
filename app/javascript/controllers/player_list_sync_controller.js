import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea"];

  initialize() {}

  copy(event) {
    const { prevValue, value } = event.detail;
    this.textareaTarget.value = this.textareaTarget.value.replace(
      prevValue,
      value
    );
  }
}
