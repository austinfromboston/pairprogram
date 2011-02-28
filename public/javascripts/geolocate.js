Geolocate = (function() {
  var self = {
    init: function() {
      if(!!navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(self.show_position);
      }
    },
    show_position: function(pos) {
      console.log(pos);
    }
  };
  return self;
})();
