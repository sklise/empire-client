_ = require 'lodash'
moment = require 'moment'
SunCalc = require 'suncalc'
marked = require 'marked'

# Returns a boolean of whether or not it is night time or not
isDaytime = ->
  now = new Date()
  sunTimes = SunCalc.getTimes(new Date(), 40.74844, -73.985664)

  {
    test: sunTimes.sunrise < now and now < sunTimes.sunset
    sunset: sunTimes.sunset
  }

setTheme = ->
  sunsets = isDaytime()
  if sunsets.test
    $('body').addClass('daytime')
    $('#sunset').text moment(sunsets.sunset).format("h:mm a")
  else
    $('body').removeClass('daytime')

centerOfItem = (item) ->
  {
    x: item.bounds.x + item.bounds.width/2
    y: item.bounds.y + item.bounds.height/2
  }

$ ->
  # Set the theme initially
  setTheme()
  # And then check every 10 minutes
  setTimeout(setTheme,10000)

  $('#instructions').html marked($('#instructions').text())

  socket = io.connect('http://sk-empire-socket.herokuapp.com:80');

  # Setup Paper
  canvas = $('#paper-canvas')[0]
  paper.setup(canvas)
  window.empire = paper.project.importSVG($("#empire-state-building-svg")[0])
  paper.view.draw()

  socket.on 'flash', ->
    observationCenter = centerOfItem empire.children['observationdeck']

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