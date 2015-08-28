import {
	Socket
}
from "phoenix"

let socket = new Socket("/ws")
socket.connect()
let chan = socket.chan("status:updates", {})
chan.join().receive("ok", chan => {
	console.log("Success!")
}).receive("error", chan => {
	console.log('Connection error');
})
chan.on("update", msg => console.log(msg))

let App = {}

export default App
