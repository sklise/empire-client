---
---

$ ->
  window.observationDeck = document.getElementById('observation-deck')

  # Three.js getting started
  scene = new THREE.Scene()
  camera = new THREE.PerspectiveCamera( 75, observationDeck.width / observationDeck.height, 0.1, 1000 )
  renderer = new THREE.WebGLRenderer()

  renderer.setSize( observationDeck.width, observationDeck.height )
  document.body.appendChild( renderer.domElement )

  material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } )
  camera.position.z = 100

  render = () ->
    requestAnimationFrame(render)
    renderer.render(scene, camera)

  socket = io.connect('http://localhost:3000');

  socket.on 'sky', (data) ->
    $('body').css({
      "background-image": "-webkit-linear-gradient( ##{data[0]} 0, ##{data[1]} 50%)"
    })
  socket.on 'lights', (data) ->
    # console.log data
    $('#wrapper').css({
      "background-image": "-webkit-linear-gradient( ##{data[0]} 0, ##{data[1]} 50%)"
    })
  socket.on 'flash', (data) ->
    console.log data
    _.each data.points, (point) ->
      geometry = new THREE.CubeGeometry(1,1,0.25)
      cube = new THREE.Mesh(geometry, material)
      scene.add(cube)
      cube.position.x = point.x
      cube.position.y = point.y

  render()