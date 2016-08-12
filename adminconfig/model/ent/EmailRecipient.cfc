component extends="Contact" persistent="true" table="conf_emailrecipients" datasource="devcpctproducts" output="false" joincolumn="emailRecipientID"  {
	property name="EmailNotifications" type="array" fieldtype="many-to-many" 
		cfc="EmailNotification" singularname="EmailNotification" 
		linktable="conf_link_emailnotifications_emailrecipients"
		fkcolumn="emailRecipientID" inversejoincolumn="emailNotificationID";
}