$(document).ready(function() {
	// User new
	$('#secret_code').keyup(function() {
		var v = $(this).val();
		$.ajax({
			type: 'GET',
			url: '/department-secret',
			data: { secret_code: v },
			dataType: 'script'
		})
	})
	$('.user').live('mouseenter', function() {
		var id = $(this).attr('id').split('_')[1];
		$('#user_' + id + ' .eventEdit').show();
	});
	// User partial
	$('.user').live('mouseleave', function() {
		var id = $(this).attr('id').split('_')[1];
		$('#user_' + id + ' .eventEdit').hide();
	});
});