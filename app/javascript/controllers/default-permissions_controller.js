import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  addPermission (event) {
    console.log(event)
    console.log("fired")
  }
}