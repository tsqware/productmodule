$.validator.setDefaults({
	//submitHandler: function() { alert("submitted!"); }
});

$().ready(function() {
	$.validator.addMethod("checkNumChildren", function(value, element) {
		var oelem = $('#numberofchildrenover5');
		var oelemval = oelem.val();
		console.log("oem: "+ oelemval.length);
		console.log("true? "+ (value.length > 0) || (oelemval.length > 0));
		return (
			(value.length > 0) || (oelemval.length > 0)
		);
	}, "");
	$.validator.addMethod("noIllChars", function(value, element) {
		return checkNoIllegalChars(value, element);
	}, "");

	$("#eventrsvp_datenight").validate({
		errorContainer: $("#eventrsvp_datenight div.error"),
		errorLabelContainer: $("#eventrsvp_datenight div.error ul"),
		wrapper: 'li',
		rules: {
			firstname: {
				required: true
			},
			lastname: {
				required: true
			},
			email: {
				required: true,
				email: true
			},
			numberofchildrenunder5: {
				checkNumChildren: true,
				number: true,
				min: 1
			},
			numberofchildrenover5: {
				number: true,
				min: 1
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
			numberofchildrenunder5: {
				checkNumChildren: "Number of Children under 5 / over 5 is required, and must be greater than zero.",
				number: "Number of Children under 5 must be a number.",
				min: "Number of Children under 5 must be greater than 0."
			},
			numberofchildrenover5: {
				number: "Number of Children over 5 must be a number.",
				min: "Number of Children over 5 must be greater than 0."
			}
		}
	});
});

function checkNoIllegalChars(val, elem) {
	var illegalChars= /[\@\(\)\<\>\;\:\\\[\]\~\$\%\^\&\*\+\=\{\}\|]/
	return !(val.match(illegalChars))
}