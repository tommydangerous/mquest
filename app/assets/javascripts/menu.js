$(document).ready(function() {
	$('.account').live('mouseover', function() {
		$('.accountMenu').show();
		return false;
	});
	$('.accountMenu ul').live('mouseover', function() {
		return false;
	})
	$(document).live('mouseover', function() {
		$('.accountMenu').hide();
	});
});