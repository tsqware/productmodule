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
				noIllChars: true
			},
			lastname: {
				noIllChars: true
			},
			email: {
				required: true,
				email: true
			},
			comments: {
				required: true,
				noIllChars: true
			}
		},
		messages: {
			firstname: {
				noIllChars: "First Name has illegal characters."
			},
			lastname: {
				noIllChars: "First Name has illegal characters."
			},
			email: {
				required: "Email is required.",
				email: "Please enter a valid email address."
			},
			comments: {
				required: "Comments is required.",
				noIllChars: "Comments has illegal characters."
			}
		}
	});
});

function checkNoIllegalChars(val, elem) {
	var illegalChars= /[\@\(\)\<\>\;\:\\\[\]\~\$\%\^\&\*\+\=\{\}\|]/
	return !(val.match(illegalChars))
}