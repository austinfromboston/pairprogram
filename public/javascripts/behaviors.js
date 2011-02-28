$(function() {
  // Reveal delete button when delete link is clicked
  $('.delete-link').click( function() {
    $(this).nextAll('.delete-block:first').show();
    return false;
  });

  // Ignore clicks on pair request, abuse report while on dashboard page
  $('.pair-request, .report-abuse', '.bids-listing.dashboard').click(function() {
    return false;
  });

  // confirm links display the closest confirm block
  $('a.confirm').click( function(ev) {
    var $confirm_target = $(this).nextAll('.confirm:first');
    if($confirm_target.length == 0) {
      $confirm_target = $(this).parent().nextAll('.confirm:first');
    }
    $confirm_target.toggle();
    return false;
  });
  Geolocate.init();

});
