component extends="Product" persistent="true" table="conf_products_eventrsvp" datasource="devcpctproducts" joincolumn="productID"  {	
	property name="eventStartDateTime" type="date" sqltype="datetime" ;
	property name="eventEndDateTime" type="date" sqltype="datetime" ;
	// use start / end date time
	property name="registrationEndDateTime" type="date" sqltype="datetime" ;
	
		
	this.constraints = {
		eventStartDateTime = {
			required=true,
			isvalid="date",
			//dateToCompare = "eventEndDateTime",
			//method="isStartBeforeEndDate"
			validator="ProductModule.adminconfig.model.ent.ProductValidator.isStartBeforeEndDate"
		},
		eventStartEndTime = {
			required=true,
			isvalid="date"
		},
		registrationEndDateTime = {
			required=true,
			isvalid="date",
			validator="ProductModule.adminconfig.model.ent.ProductValidator.isRegDeadlineBeforeStart"
		}
	};

	public boolean function isStartBeforeEndDate() {
		return DateDiff("n", this.getEventStartDateTime(), this.getEventEndDateTime()) > 0;
	}
	public boolean function isRegDeadlineBeforeStart() {
		return DateDiff("n", this.getRegistrationEndDateTime(), this.getEventStartDateTime()) > 0;
	}
}