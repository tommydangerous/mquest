$(document).ready(function() {
	$('.eventNew #user_name').autocomplete({
		source: $('.eventNew #user_name').data('autocomplete-source')
	})
})