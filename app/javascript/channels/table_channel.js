import consumer from "./consumer"

var url = window.location.pathname;
var table_id =  url.substring(url.lastIndexOf('/')+1);

consumer.subscriptions.create({ channel: "TableChannel", id: table_id }, {
  connected() {
    console.log("connected");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log("disconnected");
    // Called when the subscription has been terminated by the server
  },

  received(_data) {
    let csrfToken = document.querySelector('meta[name=csrf-token]').attributes.content.value
    fetch((url + '/players'), {
      headers: {
        "Accept": "text/javascript",
        "X-CSRF-Token": csrfToken
      },
      credentials: "include"
    })
      .then(handleErrors)
      .then(r => r.text().then(script => eval(script)))
      .catch(error => console.log(error))
  }
});

function handleErrors(response) {
  if (!response.ok) {
    throw Error(response.statusText);
  }
  return response;
}
