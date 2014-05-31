// Code to run on the Beaglebone Black.
// Instructions to follow
var Cylon = require('cylon');
var io = require('socket.io-client');

// Connect to the socket server
socket = io.connect('http://localhost:3000');

Cylon.robot({
  connection: { name: 'beaglebone', adaptor: 'beaglebone' },
  device: { name: 'led', driver: 'led', pin: 'P9_12' },

  work: function(my) {

    // when there is a flash, turn on the LED and and then turn it off after
    // 150 milliseconds.
    socket.on('flash', function () {
      my.led.turnOn();
      //after(250, my.led.turnOff)
      setTimeout(function () {
          console.log('timedout')
          my.led.turnOff()
      }, 150);
    });
  }
}).start();