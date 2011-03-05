var $dom;
beforeEach(function() {
  $dom = $('#jasmine_content');
})

jasmine.loadFixture = function(fixture_name) {
  $dom.html(Fixtures[fixture_name + '.html']);
  $('.hidden').hide();
}

jasmine.respondWithSuccess = function(response_value) {
  if ($.ajax.calls === undefined) {
    throw("have to spyOn $.ajax");
  }
  if ($.ajax.calls.length === 0) {
    throw("expected $.ajax call, didn't happen ");
  }
  $.ajax.calls[$.ajax.calls.length-1].args[0].success(response_value);
}
