describe("new search page", function() {
  beforeEach(function(){
    jasmine.loadFixture('new_search');
  })

  it("should init a Geolocate", function() {
    spyOn(Geolocate, 'init');
    pg.new_search.ready();
    expect(Geolocate.init).toHaveBeenCalled();
  })

  describe("#update_location", function() {
    it('should change the latitude and longitude values', function(){
      expect($('[name=latitude]', $dom).val()).not.toBeDefined();
      expect($('[name=longitude]', $dom).val()).not.toBeDefined();
      pg.new_search.update_location({ coords: { latitude: 34, longitude: -100.01 }});
      expect($('[name=latitude]', $dom).val()).toEqual('34');
      expect($('[name=longitude]', $dom).val()).toEqual('-100.01');
    });

    it('should hide the search block and show the choose other address link');
  });
})
