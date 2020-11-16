import { Controller } from "stimulus"

export default class extends Controller {
  allowDrop(event) {
    event.preventDefault();
  }

  swapTableCard(event) {
    event.preventDefault();
    let from_card_id = event.dataTransfer.getData('text/plain');

    let to_card_id = event.target.id;

    this.swapCard(from_card_id, to_card_id)
  }

  registerElement(event) {
    event.dataTransfer.setData('text', event.target.id);
  }

  swapCard(from_card_id, to_card_id) {
    let url = window.location.pathname;
    let csrfToken = document.querySelector('meta[name=csrf-token]').attributes.content.value;
    fetch(`${url}/swap_cards`, {
      method: 'PATCH',
      headers: {
        "Accept": "text/javascript",
        "X-CSRF-Token": csrfToken,
        "Content-Type": 'application/json'
      },
      credentials: "include",
      body: JSON.stringify({
        from_card_id: from_card_id,
        to_card_id: to_card_id
      })
    }).then(handleErrors)
      .then(r => r.text().then(script => eval(script)))
      .catch(error => console.log(error))
  }
}

function handleErrors(response) {
  if (!response.ok) {
    throw Error(response.statusText);
  }
  return response;
}