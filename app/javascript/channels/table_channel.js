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
    updatePlayers(data.players, data.gamemaster)
    goToGame(data.game_path)
  }
});

function updatePlayers(players, gamemaster) {
  if (!players) return;

  let listItems = players.map(player => `<li>${player.name} ${player.id == gamemaster.id ? 'Gamemaster' : ''}</li>`);
  document.getElementById('players').innerHTML = listItems.join('');

  let btn = document.getElementById('start_game_button')
  if(btn.dataset.player === gamemaster.id) btn.hidden = false;
}

function goToGame(path) {
  if (!path) return;

  window.location.href = path;
}
