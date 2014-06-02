SunCalc = require 'suncalc'
window.marked = require 'marked'

# Returns a boolean of whether or not it is night time or not
isDaytime = ->
  now = new Date()
  sunTimes = SunCalc.getTimes(new Date(), 40.74844, -73.985664)

  sunTimes.sunrise < now and now < sunTimes.sunset

$ ->
  if isDaytime() then $('body').addClass('daytime')

  $('#instructions').html marked($('#instructions').text())

  socket = io.connect('http://sk-empire-socket.herokuapp.com:80');

  canvas = document.getElementById('paper-canvas')
  paper.setup(canvas)
  window.empire = paper.project.importSVG(document.getElementById("empire-state-building-svg"))

  window.observationDeck
  observationCenter = {}

  setTimeout((->
    observationDeck = empire.children['observationdeck']

    observationCenter = {
      x: observationDeck.bounds.x + observationDeck.bounds.width/2
      y: observationDeck.bounds.y + observationDeck.bounds.height/2
    }
  ),500)

  paper.view.draw()

  paper.view.onFrame = -> paper.view.draw()

  socket.on 'flash', (data) ->

    circle = paper.Shape.Circle
      center: [observationCenter.x,observationCenter.y]
      radius: 1
      fillColor: 'white'

    observationDeck.addChild(circle)

    circle.onFrame = ->
      @radius += 1
      if @radius > 20
        @remove()
