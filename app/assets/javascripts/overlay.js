$(document).ready(function() {
	$('.viewTime').live('click', function() {
		$('.overlay').show();
	})
	$('.closeOverlay').live('click', function() {
		$('.overlay').hide();
	})
})