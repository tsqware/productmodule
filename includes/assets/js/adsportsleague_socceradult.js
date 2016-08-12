/*$.validator.setDefaults({

	//submitHandler: function() { alert("submitted!"); }

});*/



$(document).ready(function() {

	$("#paycontainer").fadeOut();

	/* */

	$.validator.addMethod("noIllChars", function(value, element) {

		return checkNoIllegalChars(value, element);

	}, "");

	$.validator.addMethod("textareaNoIllChars", function(value, element) {

		return checkTextareaNoIllegalChars(value, element);

	}, "");

	$.validator.addMethod("zipcode", function(value, element) {

		return value.match(/[0-9]{5}/);

	}, "")

	$.validator.addMethod(

		"ccnum", 

		function(value, element) {

			var cardtype = $("select[name='creditcardtype'] option:selected").val();

			console.log("creditcardtype: " + cardtype);		

			return validateCreditCardNum(cardtype, value);

		}, ""

	);

	$.validator.addMethod(

		"ccexp", 

		function(value, element, params) {

            var minMonth = new Date().getMonth() + 1;

            var minYear = new Date().getFullYear();

            var $month = $(params.month);

            var $year = $(params.year);



            var month = parseInt($month.val(), 10);

            var year = parseInt($year.val(), 10);

			

			console.log("min month: " + minMonth + ", min year: " + minYear);

			console.log("month: " + month + ", year: " + year);



            if ((year > minYear) || ((year === minYear) && (month >= minMonth))) {

                return true;

            } else {

                return false;

            }

		}, ""

	);



	$("#adsportsleague_socceradult").validate({

		errorContainer: $("#adsportsleague_socceradult div.error"),

		errorLabelContainer: $("#adsportsleague_socceradult div.error ul"),

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

			haddress: {

				required: true,

				noIllChars: true

			},

			haddress2: {

				required: false,

				noIllChars: true

			},

			hcity: {

				required: true,

				noIllChars: true

			},

			hstate: {

				required: true

			},

			hzip: {

				required: true,

				zipcode: true

			},

			pricetype: {

				required: true

			},

			creditcardtype: {

				required: true

			},

			creditcardnum: {

				required: true,

				ccnum: true

			},

			creditcardexp_year: {

				ccexp: { 

					month: "#creditcardexp_month",

	            	year: "#creditcardexp_year"

				}

			},

			creditcardholder: {

				required: true,

				noIllChars: true

			},

			promocode: {

				required: false,

				noIllChars: true

			},

			comments: {

				required: false,

				textareaNoIllChars: true

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

			haddress: {

				required: "Address is required.",

				noIllChars: "Address has illegal characters."

			},

			haddress2: {

				noIllChars: "Address Line 2 has illegal characters."

			},

			hcity: {

				required: "City is required.",

				noIllChars: "City has illegal characters."

			},

			hstate: {

				required: "State is required."

			},

			hzip: {

				required: "Zip Code is required.",

				zipcode: "Zip Code must be a 5-digit number."

			},

			pricetype: {

				required: "Please select Deposit or Pay In Full."

			},

			creditcardnum: {

				required: "Credit Card Number is required.",

				ccnum: "Please enter a valid credit card number."

			},

			creditcardexp_year: {

				ccexp: "Please enter a future Expiration Date."

			},

			creditcardholder: {

				required: "Name on the card is required.",

				noIllChars: "Name on the card has illegal characters."

			},

			promocode: {

				noIllChars: "Promo Code has illegal characters."

			},

			comments: {

				textareaNoIllChars: "Illegal characters in Comments."

			}

		}

	});

	



	$( "input[name='pricetype']" ).click(function() {

			// if pricetype val = 'deposit'

			//		call cfc to getPaymentInfo( pricetype='deposit' )

			//		get json structure: {pricetype, amount, balance, dueby}

			//		amount = team deposit

			// 		if not past early balance due date, 

			// 			reg total = early due date

			//			due date = early due date

			

			fval = this.value;

			$.ajax({

				url: "/plugins/ProductModule/common/model/services/SoccerAdultLeagueService.cfc",

				data: {

					method: 'getPaymentInfo',

					pricetype: fval,

					league: requestLeague

				},

				success: function(data){

					onPriceTypeClick(data);

				},

				dataType: 'html'

			});

		});

});



function checkNoIllegalChars(val, elem) {

	var illegalChars= /[\@\(\)\<\>\;\:\\\[\]\~\$\%\^\&\*\+\=\{\}\|]/

	return !(val.match(illegalChars))

}



function checkTextareaNoIllegalChars(val, elem){

	var illegalChars = /([\@\+\\\|\{\}\<\>\[\]\~\^\*]|(ftp|href|img|src))/

	return !(val.match(illegalChars))

}



function getBalance(total, deposit) {

	bal = 0;

	if (total > deposit) {

		bal = total - deposit;	

	}

	return bal;

}



function onPriceTypeClick(data) {

	console.log("DATA: " + data);

	var resultObject = $.parseJSON(data);

	

	var regTotal = resultObject.REGTOTAL;

	var regAmt = resultObject.AMOUNT;

	var regDueDate = new Date(resultObject.REGDUEDATE);

	

	balance = getBalance( regTotal, regAmt );

	

	$('#regAmount').text( '$'+regAmt.toFixed(2) );

	$('#regBalance').text( '$'+balance.toFixed(2) );/* */

	$('#regDueDate').text( (parseInt(regDueDate.getMonth())+1) + "/" + regDueDate.getDate() + "/" + regDueDate.getFullYear() );

	$("#paycontainer").show();

	//$("#paycontainer").fadeIn();

}



function validateCreditCardNum(cardtype, cardnum) {

	switch(cardtype) {

		case "MasterCard":

			return cardnum.match(/^5[0-9]{15}$/);

		case "Visa":

			return cardnum.match(/^4[0-9]{15}$/);

		case "American Express":

			return cardnum.match(/^3[0-9]{14}$/);

		case "Discover":

			return cardnum.match(/^6[0-9]{15}$/);

		default:

			return cardnum.match(/^[0-9]{16}$/);

	}

}

function isCreditCardExpValid(mo, yr) {

	var digit;

		

	//entered

	var thisMonth = mo+1;

	var thisDay = 1;

	var thisYear = yr;

	var thisDate = new Date(mo+'/'+thisDay+'/'+yr);

	

	//today

	var now = new Date();

	nowMonth = now.getMonth();

	nowDay = now.getDate();

	nowYear = now.getFullYear();

	nowformatted = nowMonth+1+'/'+nowDay+'/'+nowYear;

	now = new Date(nowMonth+1+'/'+nowDay+'/'+nowYear);

	

	console.log(thisDate);

	console.log(now);

	return thisDate < now;

	

}

