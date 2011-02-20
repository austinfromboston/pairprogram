$(function() {
  $('.delete-link').click( function() {
    $(this).nextAll('.delete-block:first').show();
    return false;
  });
});
