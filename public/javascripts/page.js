var pg = pg || {};

$(function() {
  // load per-page js code
  $.each($('body').attr('class').split(' '), function(index, value) {
    if(pg[value] !== undefined) {
      pg[value].ready();
    }
  });

});
