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
});
