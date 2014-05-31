# ---
# ---

SunCalc = require 'suncalc'
window.marked = require 'marked'

# Returns a boolean of whether or not it is night time or not
isDaytime = ->
  now = new Date()
  sunTimes = SunCalc.getTimes(new Date(), 40.74844, -73.985664)

  sunTimes.sunrise < now and now < sunTimes.sunset

$ ->
  if isDaytime() then $('body').addClass('daytime')
  window.observationDeck = document.getElementById('observation-deck')
  $('#instructions').html marked($('#instructions').text())

  socket = io.connect('http://sk-empire-socket.herokuapp.com:80');

  deck_width = $('#observation-deck').width()
  deck_height = $('#observation-deck').height()

  s = Snap("#observation-deck")

  socket.on 'flash', (data) ->
    console.log data
    point =  data.points[0]
