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
})