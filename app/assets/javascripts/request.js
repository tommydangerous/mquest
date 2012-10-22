$(document).ready(function() {
	var startCal = $('.requestStartCal');
	var endCal = $('.requestEndCal');
	// Start/End
	$('#requestCal a').live('click', function() {
		document.location.href = $(this).attr('href');
	});
	$(document).live('click', function() {
		startCal.hide();
		endCal.hide();
	})
	// Start Calendar
	$('.requestFormDateRequested #request_start').live('click', function() {
		startCal.show();
		endCal.hide();
		return false;
	})
	startCal.live('click', function() {
		return false;
	})
	// End Calendar
	$('.requestFormDateRequested #request_end').live('click', function() {
		startCal.hide();
		endCal.show();
		return false;
	})
	endCal.live('click', function() {
		return false;
	})
})