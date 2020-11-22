import { Controller } from "stimulus"

export default class extends Controller {
  allowDrop(event) {
    event.preventDefault();
  }

  swapTableCard(event) {
    event.preventDefault();
    let from_card_id = event.dataTransfer.getData('text/plain');

    let to_card_id = event.target.id;

    patchGame('swap_cards', { from_card_id: from_card_id, to_card_id: to_card_id })
  }

  registerElement(event) {
    event.dataTransfer.setData('text', event.target.id);
  }

  selectCard(event){
    event.target.classList.toggle('selected');
  }

  takeCards(_event){
    patchGame('take_cards')
  }

  takeHiddenCard(event){
    patchGame('take_hidden_card', { hidden_card_index: event.target.dataset.index })
  }

  throwCards(_event){
    let elements = document.getElementsByClassName('hand-card selected');
    let card_ids = Array.prototype.map.call(elements, element => element.id);
    patchGame('throw_cards', { card_ids: card_ids })
  }
}

function patchGame(action, payload = {}) {
  let url = window.location.pathname;
  let csrfToken = document.querySelector('meta[name=csrf-token]').attributes.content.value;
  fetch(`${url}/${action}`, {
    method: 'PATCH',
    headers: {
      "Accept": "text/javascript",
      "X-CSRF-Token": csrfToken,
      "Content-Type": 'application/json'
    },
    credentials: "include",
    body: JSON.stringify(payload)
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