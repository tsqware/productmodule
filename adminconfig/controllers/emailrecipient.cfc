/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" {
	
	property EmailRecipientService;

	public function init(fw) {
		variables.fw = fw;
		return this;
	}
	
	// *********************************  PAGES  *******************************************

	public any function default(required rc) {
		// must have rc.prod
		// or display alert
		// show: from recent event date, or all
		// get list of event dates for sidebar nav
		
		
	}
	public any function list(required rc) {
		rc.title = "Email Recipients";
		rc.emailRecipients = EmailRecipientService.list();
	}
	public any function create(required rc) {
		param name = "rc.contactName" default="";
		param name = "rc.contactEmail" default="";
		param name = "rc.contactPhone" default="";
		rc.title = "New Email Recipient";
	}
	public any function doCreate(required rc) {
		var ent = EmailRecipientService.new();
		EmailRecipientService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Email Recipient <b>#rc.contactName#</b> was saved.";
		}
		else {
			rc.message = "The Email Recipient  was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:emailrecipient.create", preserve="all");
	}	
	
	public any function edit(required rc) {
		rc.title = "Edit Email Recipient";
		if (StructKeyExists(rc, "emrec")) {
			rc.thisEmailRecipient = EmailRecipientService.load(rc.emrec);
			rc.contactName = rc.thisEmailRecipient.getContactName();
			rc.contactEmail = rc.thisEmailRecipient.getContactEmail();
			rc.contactPhone = rc.thisEmailRecipient.getContactPhone();
		}
		else {
			rc.message = "Email Recipient could not be found.";
		}
	}
	public any function doEdit(required rc) {
		WriteDump(rc.emrec);
		if (!StructKeyExists(rc, "emrec")) {
			rc.messagestatus = "notfound";
			rc.message = "Email Recipient could not be found.";			
		}
		else {
			var ent = EmailRecipientService.load(rc.emrec);
			EmailRecipientService.handleInsert(ent, rc);
			
			if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
			if (StructKeyExists(request, "message")) rc.message = request.message;
			if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
			
			if (rc.messageStatus eq "success") {
				rc.message = "The Email Recipient <b>#rc.contactName#</b> was saved.";
			}
			else {
				rc.message = "The Email Recipient was not saved.";			
			}
		}
		variables.fw.redirect(action="adminconfig:emailrecipient.edit", preserve="all");
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}

}