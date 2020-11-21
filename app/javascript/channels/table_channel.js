import consumer from "./consumer"

var url = window.location.pathname;
var tableId =  url.substring(url.lastIndexOf('/')+1);

consumer.subscriptions.create({ channel: "TableChannel", id: tableId }, {
  connected() {
    console.log("cable connected");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log("cable disconnected");
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log("cable data received");
    updatePlayers(data.players)
    goToGame(data.game_path)
    // updateGame(data.game_id)
  }
});

function updatePlayers(players) {
  if (!players) return;

  let listItems = players.map(player => `<li>${player.user_name}</li>`);
  document.getElementById('players').innerHTML = listItems.join('');
}

function goToGame(path) {
  if (!path) return;

  window.location.href = path;
}
