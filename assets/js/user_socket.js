import {Socket} from "phoenix"

let socket = new Socket("/socket", {})
socket.connect()

const session_uuid = document.cookie
  .split('; ')
  .find((row) => row.startsWith('session-uuid='))
  ?.split('=')[1];

window.page_view_channel = socket.channel("page_view:presence", {session_uuid})
window.page_view_channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
