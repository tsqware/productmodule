component persistent="true" table="conf_emailnotifications" datasource="devcpctproducts" {
	property name="emailNotificationID" ormtype="int" fieldtype="id" generator="identity";
	
	property name="EmailSender" fieldtype="many-to-one" cfc="EmailSender" fkcolumn="emailSenderID" inverse=true;
	property name="EmailRecipients" fieldtype="many-to-many" type="array" 
		cfc="EmailRecipient" singularname="EmailRecipient" 
		linktable="conf_link_emailnotifications_emailrecipients" 
		fkcolumn="emailNotificationID" inversejoincolumn="emailRecipientID";
	property name="FormConfig" cfc="FormConfig" fieldtype="many-to-one" fkcolumn="formConfigID";


	
	/**
	 * @NotEmpty
	 * @String
	 * @Max 100
	 * @NoIllegalChars
	 *
	 */
	property name="emailSubject" type="string";
	
	/**
	 * @String
	 * @Max 100
	 * @NoIllegalChars
	 *
	 */
	property name="emailHeading" type="string";
	
	/**
	 * @NotEmpty
	 * @InList venue,customer
	 *
	 */
	property name="emailGoesTo" type="string" hint="Goes to customer or venue" ;
	
	/* TODO: add new rule: 
		if the email is going to the customer, it must not have recipients (customer is the recipient)
		if the email is going to the venue, it must not have a sender (customer is the sender)
	*/
	
	this.constraints = {
		emailSubject = {required=true,size="5..100",validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"},
		emailHeading = {size="5..100",validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"},
		emailGoesTo = {required=true,inlist="venue,customer"}
	};
		
	public array function validate(ent=this) {
		result = [];
		hyrule =  new hyrule.system.core.hyrule();
		validation = hyrule.validate(this);
		result = validation.getErrors();
		
		return result;
	}
}