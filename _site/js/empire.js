(function() {
  $(function() {
    var socket;
    socket = io.connect('http://localhost:3000');
    socket.on('sky', function(data) {
      console.log('sky', data.value);
      return $('body').css('background-color', '#' + data.value);
    });
    return socket.on('lights', function(data) {
      return console.log('lights', data.value);
    });
  });

}).call(this);
