/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	
	property VenueContactService;
	property ProductService;

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
		rc.title = "Venue Contacts";
		rc.venuecontacts = VenueContactService.list();
	}
	public any function create(required rc) {
		param name = "rc.contactName" default="";
		param name = "rc.contactEmail" default="";
		param name = "rc.contactPhone" default="";
		var productType = "";
		var productTypeLink = "";
		rc.title = "New Venue Contact";

		rc.formAction = {action='adminconfig:venuecontact.doCreate'};
		if (StructKeyExists(rc, 'prod')) {
			rc.thisProduct = ProductService.loadByParam(rc.prod);
			loadAssociatedProduct(rc,'prod');
		}
	}
	public any function doCreate(required rc) {
		var ent = VenueContactService.new();
		if (StructKeyExists(rc, 'prod')) {
			var thisProduct = ProductService.loadByParam(rc.prod);
			ent.addProduct(thisProduct);
		}
		VenueContactService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Venue Contact <b>#rc.contactName#</b> was saved.";
		}
		else {
			rc.message = "The Venue Contact was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:venuecontact.create", preserve="all");
	}	
	
	public any function edit(required rc) {
		var productType = "";
		var productTypeLink = "";

		rc.title = "Edit Venue Contact";

		rc.valerrors = [];

		if (StructKeyExists(rc, "vc")) {
			rc.thisVenueContact = VenueContactService.load(rc.vc);
			rc.contactName = rc.thisVenueContact.getContactName();
			rc.contactEmail = rc.thisVenueContact.getContactEmail();
			rc.contactPhone = rc.thisVenueContact.getContactPhone();
			rc.formAction = {
				action='adminconfig:venuecontact.doEdit',
				querystring='vc=#rc.vc#'
			};
			loadAssociatedProduct(rc,'prod');
		}
		else {
			rc.message = "Venue Contact could not be found.";
		}
	}
	public any function doEdit(required rc) {
		if (!StructKeyExists(rc, "vc")) {
			rc.messagestatus = "notfound";
			rc.message = "Venue Contact could not be found.";			
		}
		else {
			var ent = VenueContactService.load(rc.vc);
		}
		VenueContactService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Venue Contact <b>#rc.contactName#</b> was saved.";
		}
		else {
			rc.message = "The Venue Contact was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:venuecontact.edit", preserve="all");
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}

}