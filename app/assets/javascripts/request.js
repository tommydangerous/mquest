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
		var startDate = $('#request_request_start').val();
		var endDate = $('#request_request_end').val();
		$('.hoursError').hide();
		if (startDate.length == 0) {
			$('#request_request_start').focus();
			return false;
		}
		else if (endDate.length == 0) {
			$('#request_request_end').focus();
			return false;
		}
		else if (isNaN(hours)) {
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
	// Ajax
	$('#request_request_start').change(function() {
		var startDate = $(this).val();
		var endDate = $('#request_request_end').val();
		if (startDate.length != 0 && endDate.length != 0) {
			// Total hours calculation
			$.ajax({
				type: 'GET',
				url: '/total-days-calculation',
				data: { start_date: startDate, end_date: endDate },
				dataType: 'script'
			})
			// Request check date
			$.ajax({
				type: 'GET',
				url: '/request-check-date',
				data: { start_date: startDate, end_date: endDate },
				dataType: 'script'
			})
		}
	})
	$('#request_request_end').change(function() {
		var startDate = $('#request_request_start').val();
		var endDate = $(this).val();
		if (startDate.length != 0 && endDate.length != 0) {
			// Total hours calculation
			$.ajax({
				type: 'GET',
				url: '/total-days-calculation',
				data: { start_date: startDate, end_date: endDate },
				dataType: 'script'
			})
			// Request check date
			$.ajax({
				type: 'GET',
				url: '/request-check-date',
				data: { start_date: startDate, end_date: endDate },
				dataType: 'script'
			})
		}
	})
	// Request check date
	$('.disabledConflict').live('click', function() {
		$('html, body').animate({ scrollTop: 0 }, 0);
		return false;
	})
})