$(document).ready(function() {
	$('.closeFlash').live('click', function() {
		$('.flash').slideUp(200);
		return false;
	});
});