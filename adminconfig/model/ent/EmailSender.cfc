component extends="Contact" persistent="true" table="conf_emailsenders" datasource="devcpctproducts" joincolumn="emailSenderID" {
	property name="EmailNotifications" type="array" fieldtype="one-to-many" 
		cfc="EmailNotification" singularname="EmailNotification" 
		fkcolumn="emailSenderID" ;
}