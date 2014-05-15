---
---

$ ->
  socket = io.connect('http://localhost:3000');

  socket.on 'sky', (data) ->
    $('body').css({
      "background-image": "-webkit-linear-gradient( ##{data[0]} 0, ##{data[1]} 50%)"
    })
  socket.on 'lights', (data) ->
    console.log data
    $('#wrapper').css({
      "background-image": "-webkit-linear-gradient( ##{data[0]} 0, ##{data[1]} 50%)"
    })
  socket.on 'flash', (data) -> console.log data