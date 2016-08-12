<cfoutput>
$.validator.setDefaults({
	//submitHandler: function() { alert("submitted!"); }
});

$().ready(function() {
	$.validator.addMethod("noIllChars", function(value, element) {
		return checkNoIllegalChars(value, element);
	}, "");

	$("##adsportsleague_socceradult").validate({
		errorContainer: $("##adsportsleague_socceradult div.error"),
		errorLabelContainer: $("##adsportsleague_socceradult div.error ul"),
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
			}
		}
	});

	$("input[name=pricetype]").click(function() {
		// if pricetype val = 'deposit'
		//		call cfc to getPaymentInfo( pricetype='deposit' )
		//		get json structure: {pricetype, amount, balance, dueby}
		//		amount = team deposit
		// 		if not past early balance due date, 
		// 			reg total = early due date
		//			due date = early due date
		console.log(this.val());
		/*$.ajax({
			url: "common.model.services.SoccerAdultLeagueService.cfc",
			method: getPaymentInfo(),
			pricetype: 
		})*/
	});
});

function checkNoIllegalChars(val, elem) {
	var illegalChars= /[\@\(\)\<\>\;\:\\\[\]\~\$\%\^\&\*\+\=\{\}\|]/
	return !(val.match(illegalChars))
}
</cfoutput>