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
    goToRound(data.round_path)
  }
});

function updatePlayers(players, gamemaster) {
  if (!players) return;

  let listItems = players.map(player => `<li>${player.name} ${player.id === gamemaster.id ? '(Gamemaster)' : ''}</li>`);
  document.getElementById('players').innerHTML = listItems.join('');

  let startGameButton = document.getElementById('start_game_button')
  startGameButton.hidden = startGameButton.dataset.player !== gamemaster.id;

  let joinTableButton = document.getElementById('join_table_button')
  joinTableButton.hidden = (players.count > 3 || players.map( p => p.id).includes(startGameButton.dataset.player));
}

function goToRound(path) {
  if (!path) return;

  window.location.href = path;
}
