component persistent="true" table="conf_contacts" datasource="devcpctproducts" {
	property name="contactID" ormtype="int" 
		fieldtype="id" generator="identity" ;
		
	//property name="contactFirstName" type="String" ;
	//property name="contactLastName" type="String" ;
	//property name="contactOrgName" type="String" ;
	property name="contactName" type="String" ;
	property name="contactEmail" type="String" ;
	property name="contactPhone" type="String" ;
	
	/*property name="receivesEmailToVenue" type="boolean"
		hint="does this person receive the email to venue" ;
	property name="sendsEmailToCustomer" type="boolean"
		hint="does this person send to the email to customer" ;
	property name="isContactForMoreInfo" type="boolean"
		hint="is this the person in the 'for more info, contact...' line" ;*/
		
	this.constraints = {
		// contactFirstName: must be person or org, must have no illegal characters, char max 50
		//contactFirstName = {validator="ProductModule.admin.model.services.venuecontact.IsPersonOrOrg", validator="cfc.ValidationExtras.hasIllegalChars"},
		//contactLastName = {validator="cfc.ValidationExtras.hasIllegalChars"},
		//contactOrgName = {validator="cfc.ValidationExtras.hasIllegalChars"},
		contactName = {required=true, validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"},
		contactEmail = {required=true,isvalid="email"},
		contactPhone = {required=true,isvalid="telephone"}
	};
	
	function getNameToDisplay() {
		var displayName = "";
		if (isSet("ContactFirstName") && isSet("ContactLastName")) {
			displayName = getContactFirstName() & " " & getContactLastName();
		}
		else if (isSet("ContactOrgName")) {
			displayName = getContactOrgName();
		}
		return displayName;
	}
}