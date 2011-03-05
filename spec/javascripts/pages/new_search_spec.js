describe("new search page", function() {
  beforeEach(function(){
    jasmine.loadFixture('new_search');
  });

  describe("#init", function(){
    it("should request current position", function() {
      var position_spy = spyOn(navigator.geolocation, 'getCurrentPosition');
      pg.new_search.ready();
      expect(position_spy).toHaveBeenCalled();
    });
    it("should display the show-geolocation link", function() {
      expect($('.show-geolocated-search')).not.toBeVisible();
      pg.new_search.ready();
      expect($('.show-geolocated-search')).toBeVisible();
    });
  });

  describe("#update_location", function() {
    it('should change the latitude and longitude values', function(){
      expect($('[name=latitude]', $dom).val()).toEqual("");
      expect($('[name=longitude]', $dom).val()).toEqual("");
      pg.new_search.update_location({ coords: { latitude: 34, longitude: -100.01 }});
      expect($('[name=latitude]', $dom).val()).toEqual('34');
      expect($('[name=longitude]', $dom).val()).toEqual('-100.01');
    });

    it('should hide the search block and show the choose other address link', function() {
      pg.new_search.update_location({ coords: { latitude: 34, longitude: -100.01 }});
      expect($("#manual-search")).not.toBeVisible();
      expect($("#geolocated-search")).toBeVisible();
    });

    it('should ping the server to get a text description of the coordinates to display to the user', function() {
      var ajaxSpy = spyOn(jQuery, 'ajax');
      pg.new_search.update_location({ coords: { latitude: 34, longitude: -100.01 }});
      expect($.ajax).toHaveBeenCalled();
      jasmine.respondWithSuccess({location: "Sasketchawan"});
      expect($('.geo-description').text()).toEqual("Sasketchawan");
    });
  });

  describe("toggle search type", function() {
    beforeEach(function() {
      pg.new_search.ready();
    });
    it("hides the geo search when manual search is requested", function() {
      $('.show-manual-search').click();
      expect($('#geolocated-search')).not.toBeVisible();
      expect($('#manual-search')).toBeVisible();
    });
    it("hides the manual search when geo search is requested", function() {
      $('.show-geolocated-search').click();
      expect($('#geolocated-search')).toBeVisible();
      expect($('#manual-search')).not.toBeVisible();
    });
  });
})
