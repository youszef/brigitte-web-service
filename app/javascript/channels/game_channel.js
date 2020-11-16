import consumer from "./consumer"

var url = window.location.pathname;
var gameId =  url.substring(url.lastIndexOf('/')+1);

consumer.subscriptions.create({ channel: "GameChannel", id: gameId }, {
  connected() {
    console.log("cable connected on game channel");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log("cable disconnected on game channel");
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log("cable data received on game channel");

    updateTableCards(data.table_card_changed)
  }
});

function updateTableCards(table_card_changed) {
  if (!table_card_changed) return;

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