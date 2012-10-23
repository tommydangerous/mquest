$(document).ready(function() {
	$('.department').live('mouseenter', function() {
		var id = $(this).attr('id').split('_')[1];
		$('#department_' + id + ' .eventEdit').show();
	});
	$('.department').live('mouseleave', function() {
		var id = $(this).attr('id').split('_')[1];
		$('#department_' + id + ' .eventEdit').hide();
	});
});