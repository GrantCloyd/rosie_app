import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
static targets = ["permissionContainer"]

  addPermission (event) {
    event.preventDefault()
    const roles =[ "subscriber", "moderator", "creator"]
    const permissions = ["reader_level",
      "commenter_level",
      "contributor_level",
      "moderator_level",
      "creator_level",
      "blocked_level" ]

    const container = this.permissionContainerTarget
    let index = container.children.length
    console.log(index)

    const permissionDiv = this.createNode("div", {className: "mt-4 p-2 border-2 border-slate-400"})

    const roleNodes = this.createSelectNodes("role_tier", roles, index)
    permissionDiv.append(roleNodes)

    const permissionNodes = this.createSelectNodes("permission_level", permissions, index)
    permissionDiv.append(permissionNodes)
    
    container.append(permissionDiv)
  }

  createSelectNodes(labelName, optionArray, index){
    // create p node, label, and select then add options to select based on array
    const pNode = this.createNode("p")
    const labelText = this.capitalize(labelName) + ":"
    const labelNode = this.createNode("label", {
      innerHTML: labelText
    })
    const breakNode = this.createNode("br")
    labelNode.setAttribute("for",  `section_role_permission_[${index}]${labelName}`)
    const selectNode = this.createNode("select")
    selectNode.setAttribute("name", `[${index}]${labelName}`)
    selectNode.setAttribute("id", `section_role_permission_[${index}]${labelName}`)
    optionArray.forEach(option => {
      const title = this.capitalize(option)
      selectNode.options.add( new Option(title, option))
    })

    pNode.append(labelNode)
    pNode.append(breakNode)
    pNode.append(selectNode)
    return pNode
  }

  capitalize(string){
   return string.split("_").map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(" ")
  }

  createNode(tag,options = {}){
    return Object.assign(document.createElement(tag),options);
  }
}