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
	// Calendar employee pop up
	$(document).on('click', '.calendar .dateDay.admin a', function() {
		var day = $(this).attr('title');
		var date = new Date(day + ' 12:00:00');
		var dateString = date.toDateString();
		var ul = $(this).closest('.dateDay').siblings('.dayEvents').children('ul');
		$('.employeesOff span').html(ul.clone());
		$('.employeesOff h1 a').text(dateString);
		$('.employeesOff h1 a').attr('href', $(this).attr('href'));
		$('.employeesOff').show();
		// This anchor's measurements and position
		var td     = $(this).closest('td');
		var offset = td.offset();
		var left   = offset.left;
		var top    = offset.top;
		var height = td.height();
		var width  = td.width();
		// Position element
		var elemHeight = $('.employeesOff').height();
		var elemWidth  = $('.employeesOff').width();
		var verticalOffset = (elemHeight - height) / 2.0;
		// If the pop up will appear off screen to the bottom
		if (top + elemHeight > $(window).height()) {
			$('.employeesOff').css('top', top - (elemHeight - height));
		}
		// If the pop up will appear off the screen to the top
		else if (top - verticalOffset < 0) {
			$('.employeesOff').css('top', top);
		}
		else {
			$('.employeesOff').css('top', top - verticalOffset);
		}
		var horizontalOffset = (elemWidth - width) / 2.0;
		// If the pop up will appear off screen to the right
		if (left + width + horizontalOffset > $(window).width()) {
			$('.employeesOff').css('left', left - (elemWidth - width));
		}
		// If the pop up will appear off screen to the left
		else if (left - horizontalOffset < 0) {
			$('.employeesOff').css('left', left);
		}
		else {
			$('.employeesOff').css('left', left - horizontalOffset);
		}
		return false;
	});
	// clicking on the page should hide the popup
	$(document).on('click', function() {
		$('.employeesOff').hide();
	});
	// clicking close on employees off popup should hide
	$(document).on('click', '.employeesOff .close a', function() {
		$('.employeesOff').hide();
		return false;
	});
});