/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	
	property EmailSenderService;
	
	// *********************************  PAGES  *******************************************

	public any function default(required rc) {
		// must have rc.prod
		// or display alert
		// show: from recent event date, or all
		// get list of event dates for sidebar nav
		
		
	}
	public any function list(required rc) {
		rc.title = "Email Senders";
		rc.emailSenders = EmailSenderService.list();
	}
	public any function create(required rc) {
		param name = "rc.contactName" default="";
		param name = "rc.contactEmail" default="";
		param name = "rc.contactPhone" default="";
		rc.title = "New Email Sender";
	}
	public any function doCreate(required rc) {
		var ent = EmailSenderService.new();
		EmailSenderService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Email Sender <b>#rc.contactName#</b> was saved.";
		}
		else {
			rc.message = "The Email Sender was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:emailsender.create", preserve="all");
	}	
	
	public any function edit(required rc) {
		rc.title = "Edit Email Sender";
		param name = "rc.valerrors" default=[];
		if (StructKeyExists(rc, "emsend")) {
			rc.thisEmailSender = EmailSenderService.load(rc.emsend);
			rc.contactName = rc.thisEmailSender.getContactName();
			rc.contactEmail = rc.thisEmailSender.getContactEmail();
			rc.contactPhone = rc.thisEmailSender.getContactPhone();
		}
		else {
			rc.message = "Email Sender could not be found.";
		}
	}
	public any function doEdit(required rc) {
		if (!StructKeyExists(rc, "emsend")) {
			rc.messagestatus = "notfound";
			rc.message = "Email Sender could not be found.";			
		}
		else {
			var ent = EmailSenderService.load(rc.emsend);
			EmailSenderService.handleInsert(ent, rc);
		
			if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
			if (StructKeyExists(request, "message")) rc.message = request.message;
			if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
			
			if (rc.messageStatus eq "success") {
				rc.message = "The Email Sender <b>#rc.contactName#</b> was saved.";
			}
			else {
				rc.message = "The Email Sender was not saved.";			
			}
		}
		variables.fw.redirect(action="adminconfig:emailsender.edit", preserve="all");
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}

}