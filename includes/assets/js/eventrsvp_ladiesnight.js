$.validator.setDefaults({
	//submitHandler: function() { alert("submitted!"); }
});

$(document).ready(function() {
	$.validator.addMethod("noIllChars", function(value, element) {
		return checkNoIllegalChars(value, element);
	}, "");

	$("#eventrsvp_ladiesnight").validate({
		errorContainer: $("#eventrsvp_ladiesnight div.error"),
		errorLabelContainer: $("#eventrsvp_ladiesnight div.error ul"),
		wrapper: 'li',
		rules: {
			firstname: {
				required: true,
				noIllChars: true
			},
			lastname: {
				required: true,
				noIllChars: true
			},
			email: {
				required: true,
				email: true
			},
			guestfirstname: {
				checkNumChildren: true,
				noIllChars: true
			},
			guestfirstname: {
				noIllChars: true
			},
			guestemail: {
				email: true
			}
		},
		messages: {
			firstname: {
				required: "First Name is required.",
				noIllChars: "First Name has illegal characters."
			},
			lastname: {
				required: "Last Name is required.",
				noIllChars: "First Name has illegal characters."
			},
			email: {
				required: "Email is required.",
				email: "Please enter a valid email address."
			},
			guestfirstname: {
				noIllChars: "Guest First Name has illegal characters."
			},
			guestlastname: {
				noIllChars: "Guest Last Name has illegal characters."
			},
			guestemail: {
				email: "Please enter a valid Guest Email Address."
			}
		}
	});
});

function checkNoIllegalChars(val, elem) {
	var illegalChars= /[\@\(\)\<\>\;\:\\\[\]\~\$\%\^\&\*\+\=\{\}\|]/
	return !(val.match(illegalChars))
}