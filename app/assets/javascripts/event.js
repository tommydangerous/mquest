$(document).ready(function() {
	$('.event').live('mouseenter', function() {
		var id = $(this).attr('id').split('_')[1];
		$('#event_' + id + ' .eventEdit').show();
	});
	$('.event').live('mouseleave', function() {
		var id = $(this).attr('id').split('_')[1];
		$('#event_' + id + ' .eventEdit').hide();
	});
});