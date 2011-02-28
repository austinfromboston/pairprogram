var $dom = $('#jasmine_content');
beforeEach(function() {
})

jasmine.loadFixture = function(fixture_name) {
  $dom.html(Fixtures[fixture_name + '.html']);
}
