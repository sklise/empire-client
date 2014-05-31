gify = require 'gify'
gify '../sourcevid.mp4', 'flashes.gif', {
    width: 1000
  }, (err) ->
  if (err) then throw err
  console.log "done"