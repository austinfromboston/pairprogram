pg.new_searches = (function() {
  var page = {
    ready: function() {
      if(!!navigator.geolocation) {
        $('.show-geolocated-search').show();
        navigator.geolocation.getCurrentPosition(page.update_location);
        $('.show-geolocated-search').click(page.show_geo_search);
        $('.show-manual-search').click(page.show_manual_search);
      }
    },
    update_location: function(position) {
      page.show_geo_search();
      $('#search_latitude').val(position.coords.latitude);
      $('#search_longitude').val(position.coords.longitude);
      $.getJSON("/locations.json", position.coords, page.show_location);
    },
    show_location: function(data) {
      $('.geo-description').text(data.location);
    },
    show_geo_search: function(ev) {
      $('#manual-search').hide();
      $('#geolocated-search').show();
    },
    show_manual_search: function(ev) {
      $('#manual-search').show();
      $('#geolocated-search').hide();
    }
  };
  return page;
})();
