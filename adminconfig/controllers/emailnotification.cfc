/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	
	property EmailNotificationService;
	property EmailRecipientService;
	property EmailSenderService;
	property FormConfigService;
	property ProductService;
	
	// *********************************  PAGES  *******************************************

	public any function default(required rc) {
		// must have rc.prod
		// or display alert
		// show: from recent event date, or all
		// get list of event dates for sidebar nav
		
		
	}
	public any function list(required rc) {
		rc.productTypes = ProductTypeService.list();
	}
	public any function create(required rc) {
		param name = "rc.emailSubject" default="";
		param name = "rc.emailGoesTo" default="";
		param name = "rc.emailSenderID" default="";
		param name = "rc.emailRecipientID" default="";
		param name = "rc.hasGoTo" default= false;
		param name = "rc.hasConf" default= true;
		
		rc.title = "New Email Notification";
		rc.emailSenderList = EmailSenderService.list();
		rc.emailRecipientList = EmailRecipientService.list();
		rc.formAction = {
			action='adminconfig:emailnotification.doCreate'
		};

		if (!StructKeyExists(rc, "conf")) {
			rc.hasConf = false;
			rc.message = "Email Notification must be associated with a form.";
			return;
		}
		else {
			rc.formConfigID = rc.conf;
			confObj = FormConfigService.load(rc.conf);
			if (!IsBoolean(confObj)) {
				rc.formName = confObj.getFormName();
				rc.formParam = confObj.getFormParam();

				rc.formConfigLink = Replace(rc.formParam, "-", "", "all");
				rc.formAction = {
					action='adminconfig:emailnotification.doCreate',
					querystring='conf=#rc.conf#'
				};
				rc.formEditLink = {
					action='adminconfig:formconfig.edit', 
					querystring='conf=#rc.conf#'
				};
				rc.formAction.querystring='conf=#rc.conf#';

				if(confObj.hasProduct()) {
					rc.prod = confObj.getProduct().getProductURLParam();
					loadAssociatedProduct(rc,"prod");
				}
			}
			else {
				rc.hasConf = false;
				rc.message = "Email Notification must be associated with a form.";
			}
			if (StructKeyExists(rc, "goesto")) {
				rc.emailGoesTo = rc.goesto;
			}
		}
		
	}
	public any function doCreate(required rc) {
		if (!StructKeyExists(rc, "conf")) {
			rc.hasConf = false;
			rc.message = "Email Notification must be associated with a form.";
			variables.fw.redirect(action="adminconfig:emailnotification.create", preserve="all");
			return;
		}
		var ent = EmailNotificationService.new();
		populateAssociatedValues(rc,ent);
		EmailNotificationService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Email Notification is now saved.";
		}
		else {
			rc.message = "The Email Notification was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:emailnotification.create", preserve="all");
	}	
	
	public any function edit(required rc) {
		rc.title = "Edit Email Notification";
		rc.messagestatus = "";
		if (StructKeyExists(rc, "emnot")) {
			rc.thisEmailNotification = EmailNotificationService.load(rc.emnot);
			if (!IsBoolean(rc.thisEmailNotification)) {
				rc.formAction = {
						action='adminconfig:emailnotification.doEdit',
						querystring='emnot=#rc.emnot#'
					};
				rc.emailSubject = rc.thisEmailNotification.getEmailSubject();
				rc.emailGoesTo = rc.thisEmailNotification.getEmailGoesTo();
				rc.emailSenderID = '';
				rc.emailRecipientID = "";
				
				rc.emailSenderList = EmailSenderService.list();
				rc.emailRecipientList = EmailRecipientService.list();

				if(rc.thisEmailNotification.hasEmailSender())
					rc.emailSenderID = rc.thisEmailNotification.getEmailSender().getContactID();

				//WriteDump(rc.thisEmailNotification.getEmailRecipients());
				if(rc.thisEmailNotification.hasEmailRecipient()) {
					for(var r in rc.thisEmailNotification.getEmailRecipients()) {
						rc.emailRecipientID = ListAppend(rc.emailRecipientID, r.getContactID(), ',');
					}				
				}
				if (rc.thisEmailNotification.hasFormConfig()) {
					confObj = rc.thisEmailNotification.getFormConfig();
					rc.formName = confObj.getFormName();

					rc.formParam = confObj.getFormParam();

					rc.formConfigLink = Replace(rc.formParam, "-", "", "all");
					rc.formEditLink = {
						action='adminconfig:formconfig.edit', 
						querystring='conf=#confObj.getFormConfigID()#'
					};

					if(confObj.hasProduct()) {
						rc.prod = confObj.getProduct().getProductURLParam();
						loadAssociatedProduct(rc,"prod");
					}
				}

				
				//rc.emailRecipientID = rc.thisEmailNotification.getProductTypeClassName();	
			}
			else {
				rc.messagestatus = "notfound";
				rc.message = "Email Notification could not be found.";
			}			
		}
		else {
			rc.messagestatus = "notfound";
			rc.message = "Email Notification could not be found.";
		}
	}
	public any function doEdit(required rc) {
		if (!StructKeyExists(rc, "emnot")) {
			rc.message = "Email Notification could not be found.";
		}
		else {
			var ent = EmailNotificationService.load(rc.emnot);
			populateAssociatedValues(rc,ent);
			EmailNotificationService.handleInsert(ent, rc);

			if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
			if (StructKeyExists(request, "message")) rc.message = request.message;
			if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
			
			if (rc.messageStatus eq "success") {
				rc.message = "The Email Notification <b>#rc.emailSubject#</b> was saved.";
			}
			else {
				rc.message = "The Email Notification was not saved.";			
			}
		}
		variables.fw.redirect(action="adminconfig:emailnotification.edit", preserve="all");
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}

	private function populateAssociatedValues(rc,ent) {
		if (ent.hasEmailSender()) {
			ent.setEmailSender(JavaCast("null", ""));
		}
		
		if (ent.hasEmailRecipient()) {
			ent.setEmailRecipients(JavaCast("null", ""));
		}
		
		if (StructKeyExists(rc, "emailRecipientID")) {
			var emailRecipientArray = [];
			for (l=1; l<= ListLen(rc.emailRecipientID); l++) {
				emailRecipient = EmailRecipientService.load(ListGetAt(rc.emailRecipientID, l));
				ArrayAppend(emailRecipientArray, emailRecipient);
			}
			ent.setEmailRecipients(emailRecipientArray);
		}
		
		if (StructKeyExists(rc, "emailSenderID")) {
			var emailSender = EmailSenderService.load(rc.emailSenderID);
			ent.setEmailSender(emailSender);
		}
		
		if (StructKeyExists(rc, "formID")) {
			var formConfig = FormConfigService.load(rc.formID);
			ent.setFormConfig(formConfig);
		}		
		
	}

}