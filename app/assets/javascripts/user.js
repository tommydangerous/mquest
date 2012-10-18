$(document).ready(function() {
	$('.user').live('mouseenter', function() {
		var id = $(this).attr('id').split('_')[1];
		$('#user_' + id + ' .eventEdit').show();
	});
	$('.user').live('mouseleave', function() {
		var id = $(this).attr('id').split('_')[1];
		$('#user_' + id + ' .eventEdit').hide();
	});
});