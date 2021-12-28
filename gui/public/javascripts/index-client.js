const ws = new WebSocket('ws://localhost:3000');

let number = 0;

const update = function update(val) {
  number = val;
  document.getElementById('number').value = number;
}

ws.onmessage = (msgEvt) => {
  update(msgEvt.data);
};
