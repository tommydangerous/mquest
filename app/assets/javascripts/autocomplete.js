$(document).ready(function() {
	$('.eventNew #user_name').autocomplete({
		source: $('.eventNew #user_name').data('autocomplete-source')
	})
	$('.eventSearch #search').autocomplete({
		source: $('.eventSearch #search').data('autocomplete-source')
	})
	$('#event_name').autocomplete({
		source: $('#event_name').data('autocomplete-source')
	})
})