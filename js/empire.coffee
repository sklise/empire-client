---
---

$ ->
  window.observationDeck = document.getElementById('observation-deck')

  # Three.js getting started
  scene = new THREE.Scene()
  camera = new THREE.PerspectiveCamera(
    90,
    observationDeck.offsetWidth / observationDeck.offsetHeight,
    0.1,
    1000
  )

  renderer = new THREE.CanvasRenderer({
    alpha: true
  })

  renderer.setSize( observationDeck.offsetWidth, observationDeck.offsetHeight )
  observationDeck.appendChild( renderer.domElement )

  material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } )
  camera.position.set(
    0,
    0,
    100)

  circleMaterial = new THREE.MeshBasicMaterial({color: 0xffffff})
  circleGeom = new THREE.CircleGeometry(2, 32)
  circle = new THREE.Mesh(circleGeom, circleMaterial)
  circle.position.set(0,0,1)
  scene.add(circle)

  render = () ->
    requestAnimationFrame(render)
    renderer.render(scene, camera)

  socket = io.connect('http://localhost:3000');

  socket.on 'sky', (data) ->
    $('body').css({
      "background-image": "-webkit-linear-gradient( ##{data[0]} 0, ##{data[1]} 50%)"
    })

  socket.on 'lights', (data) ->
    $('#wrapper').css({
      "background-image": "-webkit-linear-gradient( ##{data[0]} 0, ##{data[1]} 50%)"
    })

  socket.on 'flash', (data) ->
    console.log data
    _.each data.points, (point) ->
    point =  data.points[0]

    geometry = new THREE.BoxGeometry(1,1,0.25)
    cube = new THREE.Mesh(geometry, material)
    scene.add(cube)
    cube.position.x = point.x
    cube.position.y = point.y

  render()