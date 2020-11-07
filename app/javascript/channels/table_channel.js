import consumer from "./consumer"

let url = window.location.pathname
let table_id =  url.substring(url.lastIndexOf('/')+1);
consumer.subscriptions.create({ channel: "TableChannel", table: table_id }, {
  connected() {
    console.log("connected");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log("disconnected");
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log("broadcast received");
    console.log(data['players']);
    // Called when there's incoming data on the websocket for this channel
  }
});
