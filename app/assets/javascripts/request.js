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
	// Request form submit
	$('.requestFormSubmit').live('click', function() {
		var hours = parseInt($('#request_total_hours').val());
		var purpose = parseInt($('#request_purpose_id').val());
		$('.hoursError').hide();
		if (isNaN(hours)) {
			$('.hoursErrorNone').show();
			$('#request_total_hours').focus();
			return false;
		}
		else if (purpose == 5 && hours < 4 || purpose == 7 && hours < 4) {
			$('.hoursError4').show();
			$('#request_total_hours').focus();
			return false;
		}
		else if (purpose == 4 && hours < 8) {
			$('.hoursError8').show();
			$('#request_total_hours').focus();
			return false;
		}
	})
	// Total time
	$('#request_total_hours').keyup(function() {
		var hours = parseInt($('#request_total_hours').val());
		var purpose = parseInt($('#request_purpose_id').val());
		if (!isNaN(hours)) {
			$('.hoursErrorNone').hide();
		}
		if (purpose == 5 && hours >= 4 || purpose == 7 && hours >= 4) {
			$('.hoursError4').hide();
		}
		if (purpose == 4 && hours >= 8) {
			$('.hoursError8').hide();
		}
	})
})