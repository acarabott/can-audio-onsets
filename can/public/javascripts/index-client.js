const ws = new WebSocket('ws://localhost:3000');

ws.onmessage = (msgEvt) => {
  document.getElementById('number').value = msgEvt.data;
};
