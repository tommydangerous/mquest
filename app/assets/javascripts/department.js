$(document).ready(function() {
	$('.department').live('mouseenter', function() {
		var id = $(this).attr('id').split('_')[1];
		$('#department_' + id + ' .eventEdit').show();
	});
	$('.department').live('mouseleave', function() {
		var id = $(this).attr('id').split('_')[1];
		$('#department_' + id + ' .eventEdit').hide();
	});
	$('.departmentReq').live('click', function() {
		var url = $('.departmentReqSearch select').val();
		window.location.href = url;
	})
});