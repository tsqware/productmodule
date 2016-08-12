
component extends="mura.plugin.pluginGenericEventHandler" {
	$ = application.serviceFactory.getBean('$');
	public SportsLeaguePayment function init(whichleague) 
	{
		this.league = whichleague;
		//WriteOutput("datediff? " & DateDiff('d',this.league.getAdLeagueRegDueDate(), now()) & "<br>");
		//WriteDump(this);
		//abort;
		return this;	
	}
	
	public function getPrice(pricetype) {
		var price = 0;
		// WriteDump(var=arguments, label="getPriceArgs");
		// WriteDump(var=request, label="request getPrice");
		// abort;
		
		// if this is a deposit
		if (IsDefined("arguments.pricetype")) {
			if (pricetype == "deposit") {
				price = getDeposit();
			}
			else if (pricetype == "payinfull") {
				price = getFullPrice();
			}
		}
		return price;
	}
	public function getRegTotal() {
		if (isBeforeDueDate()) {
			price = this.league.getAdLeagueTeamEarlyPrice();
		}
		else {
			price = this.league.getAdLeagueTeamPrice();
		}
	}
	function getBalanceDueDate() {
		var dueDate = this.league.getAdLeagueRegDueDate();
		if (isBeforeDueDate()) {
			dueDate = this.league.getAdLeagueEarlyDueDate();
		}
		else if (IsDefined(this.league.getAdLeagueRegDueDate()) && DateDiff('d',this.league.getAdLeagueRegDueDate(), now()) <= 0) {
			dueDate = this.league.getAdLeagueRegDueDate();
		}
		return dueDate;
	}
	function isBeforeDueDate() {
		return (
			!IsNull(this.league.getAdLeagueEarlyDueDate()) 
			&& IsDate(this.league.getAdLeagueEarlyDueDate())
			&& DateDiff('d',this.league.getAdLeagueEarlyDueDate(), now()) <= 0);
	}

	public function getFullPrice() {
		if (isBeforeDueDate()) {
			return this.league.getAdLeagueTeamEarlyPrice();
		}
		else {
			return this.league.getAdLeagueTeamPrice();
		}	
	}
	
	private function getDeposit() {
    	var price = 0;
    	if (this.league.getAdLeagueTeamDeposit() > 0) 
			var price = this.league.getAdLeagueTeamDeposit();
		return price;
	}
	
	public function getBalanceDue() {
		var bal = 0;
		var full = getFullPrice();
		var dep = getDeposit();
		if (getPrice() == dep) {
			if (full - dep > 0) {
				bal = full - dep;
			}			
		}		
		return bal;
	}
	
}