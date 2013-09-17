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
		// if there is no start date
		if (startDate.length == 0) {
			$('#request_request_start').focus();
			return false;
		}
		// if there is no end date
		else if (endDate.length == 0) {
			$('#request_request_end').focus();
			return false;
		}
		// if total hours is blank
		else if (isNaN(hours)) {
			$('.hoursErrorNone').show();
			$('#request_total_hours').focus();
			return false;
		}
		// if purpose is sick or vaction, minimum hours used is 4
		else if (purpose == 5 && hours < 4 || purpose == 7 && hours < 4) {
			$('.hoursError4').show();
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
	// Whenever user clicks half day, change its checked attribute
	$(document).on('click', '#request_half_day', function() {
		if ($(this).attr('check_value') == '1') {
			$(this).attr('check_value', '0')
			$(this).prop('checked', false);
		}
		else {
			$(this).attr('check_value', '1');
			$(this).prop('checked', true);
		}
		var half_day  = $('#request_half_day').attr('check_value');
		var endDate   = $('#request_request_end').val();
		var startDate = $('#request_request_start').val();
		if (startDate.length != 0 && endDate.length != 0) {
			// Total days calculation
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
				data: { 
					start_date: startDate,
					end_date: endDate,
					half_day: half_day
				},
				dataType: 'script'
			})
		}
	});
	// Ajax
	$('#request_request_start').change(function() {
		var half_day  = $('#request_half_day').attr('check_value');
		var endDate   = $('#request_request_end').val();
		var startDate = $(this).val();
		if (startDate.length != 0 && endDate.length != 0) {
			// Total days calculation
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
				data: { 
					start_date: startDate,
					end_date: endDate,
					half_day: half_day
				},
				dataType: 'script'
			})
		}
	})
	$('#request_request_end').change(function() {
		var half_day  = $('#request_half_day').attr('check_value');
		var endDate   = $(this).val();
		var startDate = $('#request_request_start').val();
		if (startDate.length != 0 && endDate.length != 0) {
			// Total days calculation
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
				data: { 
					start_date: startDate,
					end_date: endDate,
					half_day: half_day
				},
				dataType: 'script'
			})
		}
	})
	// Request check date
	$('.disabledConflict').live('click', function() {
		// if request is scheduled and there are conflicts
		if ($('#request_scheduled').is(':checked')) {
			$('html, body').animate({ scrollTop: 0 }, 0);
			return false;
		}
	})
})