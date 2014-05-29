---
---

mapto = (x, start_min, start_max, stop_min, stop_max) ->
  stop_min + (stop_max - stop_min) * ((x - start_min) / (start_max - start_min))

make_flash = (svg, point,start_width,start_height,end_width,end_height) ->
  new_x = mapto(point.x, 0, start_width, 0, end_width)
  new_y = mapto(point.y, 0, start_height, 0, end_height)

  f = svg.filter([Snap.filter.shadow(0,0,3,"#ECD93E"), Snap.filter.blur(2)])
  x = svg.ellipse(new_x, new_y, 4, 4).attr({
    stroke: '#ffffff',
    'strokeWidth': 2,
    fill: '#ffffff',
    filter: f
  });
  setTimeout((-> x.remove()), 1000)

$ ->
  window.observationDeck = document.getElementById('observation-deck')

  socket = io.connect('http://sk-empire-socket.herokuapp.com:80');

  deck_width = $('#observation-deck').width()
  deck_height = $('#observation-deck').height()

  s = Snap("#observation-deck")

  socket.on 'flash', (data) ->
    console.log data
    point =  data.points[0]
    make_flash(s, point,data.width,data.height,deck_width,deck_height)
