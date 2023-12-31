import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "current", "main" ]

    async currentTargetConnected() {
     console.log("con fired")
     let currentFlash = this.currentTarget
     await new Promise(r => setTimeout(r, 3000))
      currentFlash.remove()
  }

 
}
