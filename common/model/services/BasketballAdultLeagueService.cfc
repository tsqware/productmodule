component extends="mura.cfobject" {
	$ = application.serviceFactory.getBean('$');

	public BasketballAdultLeagueService function init() {
		return this;
	}

	remote any function getPaymentInfo( 
		required String pricetype,
		required String league
	) returnformat="json" {
		var thisbean = $.getBean('content').loadBy(
				filename='product-module/adult-basketball-leagues/#arguments.league#', siteID='cpct');
		var result = {};
		var stresult = {};
		if (pricetype=="deposit") {
			stresult.amount = thisbean.getAdLeagueTeamDeposit();
			if (IsDate(thisbean.getAdLeagueEarlyDueDate()) && DateDiff('d', now(), thisbean.getAdLeagueEarlyDueDate()) >= 0) {
				stresult.regtotal = thisbean.getAdLeagueTeamEarlyPrice();
				stresult.regduedate = thisbean.getAdLeagueEarlyDueDate();
			}
			else {
				stresult.regtotal = thisbean.getAdLeagueTeamPrice();
				stresult.regduedate = thisbean.getAdLeagueRegDueDate();
			}
		}
		else if(pricetype=="payinfull") {
			if (IsDate(thisbean.getAdLeagueEarlyDueDate()) && DateDiff('d', now(), thisbean.getAdLeagueEarlyDueDate()) >= 0) {
				stresult.regtotal = thisbean.getAdLeagueTeamEarlyPrice();
				stresult.amount = stresult.regtotal;
				stresult.regduedate = thisbean.getAdLeagueEarlyDueDate();
			}
			else {
				stresult.regtotal = thisbean.getAdLeagueTeamPrice();
				stresult.amount = stresult.regtotal;
				stresult.regduedate = thisbean.getAdLeagueRegDueDate();
			}
		}
		
		//WriteDump(stresult);
		result = SerializeJSON(stresult);
		//WriteOutput(result);
		//abort;
		//var sal = $.content();
		//WriteDump(sal.getAllValues());
		//abort;*/
		return result;
	}
}