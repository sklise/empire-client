window._ = require 'lodash'
window.SunCalc = require 'suncalc'
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
    window.observationDeck = empire.children['observationdeck']

    observationCenter = {
      x: observationDeck.bounds.x + observationDeck.bounds.width/2
      y: observationDeck.bounds.y + observationDeck.bounds.height/2
    }
  ),500)

  paper.view.draw()

  # paper.view.onFrame = -> paper.view.draw()

  socket.on 'flash', ->
    circle = paper.Shape.Circle
      center: [observationCenter.x,observationCenter.y]
      radius: 1
      fillColor: 'rgba(255,255,255,0.8)'
      shrinking: false
      shadowColor: 'rgba(255,255,255,0.8)'
      shadowBlur: 30

    empire.addChild(circle)

    circle.onFrame = ->
      if @shrinking
        @shadowBlur -= 2
        @radius -= 2
        if @radius < 8
          @remove()
      else
        @radius += 1
        if @radius > 8
          @shadowBlur = 60
        if @radius > 12
          @shrinking = true