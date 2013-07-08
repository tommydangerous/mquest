$(document).ready(function() {
	var month = $('.selectMonth input');
	var year = $('.selectYear input');
	var regex = /[0-9]+/
	month.keyup(function() {
		var d = new Date();
		var day = d.getDate();
		var v = month.val();
		var yv = year.val();
		if (!v.match(regex) || parseInt(v) > 12) {
			month.val('');
		}
		else if (v.length == 2 && yv.length == 0) {
			year.focus()
		}
		else if (v.length == 2 && yv.length == 2) {
			document.location.href = '/?date=' + yv + '-' + v + '-' + day;
		}
	})
	year.keyup(function() {
		var d = new Date();
		var day = d.getDate();
		var v = year.val();
		var mv = month.val();
		if (!v.match(regex)) {
			year.val('');
		}
		else if (v.length > 2) {
			var x = v[0]
			var y = v[1]
			year.val(x + y)
		}
		else if (v.length == 2 && mv.length == 0) {
			month.focus();
		}
		else if (v.length == 2 && mv.length >= 1) {
			document.location.href = '/?date=' + v + '-' + mv + '-' + day;
		}
	})
	// Mouse moving around
	$(document).on('click', '.calendar .dateDay a', function() {
		var day = $(this).attr('title');
		var date = new Date(day + ' 12:00:00');
		var dateString = date.toDateString();
		var offset = $(this).offset();
		var ul = $(this).closest('.dateDay').siblings('.dayEvents').children('ul');
		$('.employeesOff span').html(ul.clone());
		$('.employeesOff h1 a').text(dateString);
		$('.employeesOff h1 a').attr('href', $(this).attr('href'));
		$('.employeesOff').show();
		// This anchor's measurements and position
		var left = offset.left;
		var top  = offset.top;
		var height = $(this).height();
		var width  = $(this).width();
		// Position element
		var elemHeight = $('.employeesOff').height();
		var elemWidth  = $('.employeesOff').width();
		if (top + elemHeight > $(window).height()) {
			$('.employeesOff').css('top', top - (elemHeight - height));
		}
		else {
			$('.employeesOff').css('top', top - 1);
		}
		if (left - elemWidth < 0) {
			$('.employeesOff').css('left', left + width);
		}
		else {
			$('.employeesOff').css('left', left - elemWidth);
		}
		return false;
	});
	// clicking close on employees off popup should hide
	$(document).on('click', '.employeesOff .close a', function() {
		$('.employeesOff').hide();
		return false;
	});
});