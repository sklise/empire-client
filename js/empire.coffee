---
---

$ ->
  socket = io.connect('http://localhost:3000');

  socket.on 'sky', (data) ->
    console.log('sky',data.value);
    $('body').css('background-color','#'+data.value);

  socket.on 'lights', (data) ->
    console.log('lights',data.value);
