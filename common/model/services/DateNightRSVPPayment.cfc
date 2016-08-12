
component extends="mura.plugin.pluginGenericEventHandler" {
	$ = application.serviceFactory.getBean('$');
	public DateNightRSVPPayment function init() 
	{
		this.priceover5obj = $.getBean('content').loadBy(filename='product-module/event-rsvp-prices/adult-price');
		this.priceover5 = this.priceover5obj.getRsvpPriceAmount();
		this.priceunder5obj = $.getBean('content').loadBy(filename='product-module/event-rsvp-prices/children-price');
		this.priceunder5 = this.priceunder5obj.getRsvpPriceAmount();
		return this;	
	}
	
	public function getPrice() {
		var price = 0;
		var numChildrenUnder5 = 0;
		var numChildrenOver5 = 0;
		
		
		if (Len(Trim(form.numberofchildrenunder5)) > 0) numChildrenUnder5 = form.numberofchildrenunder5;
		var priceUnder5 = this.priceUnder5;
		if (Len(Trim(form.numberofchildrenover5)) > 0) var numChildrenOver5 = form.numberofchildrenover5;
		var priceOver5 = this.priceOver5;
		
		price = numChildrenUnder5 * priceUnder5 + numChildrenOver5 * priceOver5;
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