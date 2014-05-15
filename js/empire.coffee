---
---

$ ->
  socket = io.connect('http://localhost:3000');

  socket.on 'sky', (data) -> $('body').css('background-color','#'+data);
  socket.on 'lights', (data) ->
    $('#wrapper').css('background-color',"#"+data)
  socket.on 'flash', (data) -> console.log data