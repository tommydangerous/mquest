$(document).ready(function() {
	$('.viewTime').live('click', function() {
		$('.overlay').show();
		$('body').addClass('noOverflow');
		return false;
	})
	$('.closeOverlay').live('click', function() {
		$('.overlay').hide();
		$('body').removeClass('noOverflow');
		return false;
	})
})