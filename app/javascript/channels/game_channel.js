import consumer from "./consumer"

var url = window.location.pathname;
var gameId =  url.substring(url.lastIndexOf('/')+1);

consumer.subscriptions.create({ channel: "GameChannel", id: gameId }, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received() {
    updateTable()
  }
});

function updateTable() {
  let csrfToken = document.querySelector('meta[name=csrf-token]').attributes.content.value
  fetch(url, {
    headers: {
      "Accept": "text/javascript",
      "X-CSRF-Token": csrfToken
    },
    credentials: "include"
  }).then(handleErrors)
    .then(r => r.text().then(script => eval(script)))
    .catch(error => console.log(error))
}

function handleErrors(response) {
  if (!response.ok) {
    throw Error(response.statusText);
  }
  return response;
}