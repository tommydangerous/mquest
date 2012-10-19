$(document).ready(function() {
	$('.viewTime').live('click', function() {
		$('.overlay').show();
		$('body').addClass('noOverflow');
	})
	$('.closeOverlay').live('click', function() {
		$('.overlay').hide();
		$('body').removeClass('noOverflow');
	})
})