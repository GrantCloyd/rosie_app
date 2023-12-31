import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "current"]

    async currentTargetConnected() {
        await new Promise(_ => setTimeout(_, 2750))
        this.currentTarget.remove()
  }
}
