import consumer from "./consumer"

var url = window.location.pathname;
var roundId =  url.substring(url.lastIndexOf('/')+1);

consumer.subscriptions.create({ channel: "RoundChannel", id: roundId }, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    updateTable(data)
  }
});

async function updateTable(data) {
  if (data.thrown_card) {
    updatePile(data.thrown_card);
    await new Promise(resolve => setTimeout(resolve, 1000));
  }

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
function updatePile(thrown_card) {
  document.querySelectorAll('.pile .deep-indent').forEach(img => img.classList.remove('deep-indent'));
  let pile = document.getElementById('pile');
  let total = pile.childElementCount;
  let img = document.createElement("img")

  img.src = thrown_card.image_path;
  img.style = `--index: ${total - 1}; --total: ${total}`;
  pile.appendChild(img)
}

function handleErrors(response) {
  if (!response.ok) {
    throw Error(response.statusText);
  }
  return response;
}