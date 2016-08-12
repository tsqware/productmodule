/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller"{
	property ProductService;
	property EventRSVPService;
	property ProductTypeService;
	property VenueContactService;
	property FormConfigService;
	property PriceService;
	property PriceTypeService;

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
		
	}
	public any function create(required rc) {
		param name = "rc.productName" default="";
		param name = "rc.productParam" default="";
		param name = "rc.isSoldOut" default="0";
		param name = "rc.messagestatus" default="";
		rc.productTypes = ProductTypeService.list();
		rc.venueContacts = VenueContactService.list();
		rc.formConfigs = FormConfigService.list();
		
		rc.valErrors = [];
		if (StructKeyExists(rc, "prodtype")) {
			handleProductType(rc, rc.prodtype);
			rc.productTypeObj = ProductTypeService.loadByParam(rc.prodtype);
			rc.productTypeID = rc.productTypeObj.getProductTypeID();
			rc.productTypeName = rc.productTypeObj.getProductTypeName();
			rc.productTypeClassName = rc.productTypeObj.getProductTypeClassName();
		}
		else {
			rc.message = "The product type for this product was not found.";
			rc.messagestatus = "producttypenotfound";
			return;
		}
		
		//WriteDump(rc);
		//abort;
	}
	public any function doCreate(required rc) {
		var ent = ProductService.new();
		
		removeAssociatedValues(ent);
		populateAssociatedValues(rc,ent);		
		
		WriteDump(rc);
		WriteDump(ent);
		abort;
		FormConfigService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Form Config for form #rc.formName# is now saved.";
		}
		else {
			rc.message = "The Form Config for form #rc.formName# was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:formconfig.create", preserve="all");
	}
	
	public any function edit(required rc) {
		
	}
	public any function doEdit(required rc) {
		
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}
	
	private function handleProductType(rc, pt) {
		/*
			if this is an Event RSVP, set default values for eventdate and registrationEndDate
		*/
		switch(arguments.pt) {
			case "event-rsvp":
				rc.eventDate = "";
				rc.registrationEndDate = "";
				rc.prices = PriceService.list();				
				break;
			case "league-registration":
				break;
		}
	}
	
	private function removeAssociatedValues(ent) {
		if (ent.hasVenueContact()) {
			ent.setVenueContacts(JavaCast("null", ""));
		}		
	}
	
	private function populateAssociatedValues(rc,ent) {
		var venueContactArray = [];
		if(StructKeyExists(rc, "contactID")) {
			for(contact in rc.contactID) {
				venueContact = VenueContactService.load(contact);
				ArrayAppend(venueContactArray, venueContact);
			}
			ent.setVenueContacts(venueContactArray);
		}
		
		if (StructKeyExists(rc, "productTypeID")) {
			var productType = ProductTypeService.load(rc.productTypeID);
			ent.setProductType(productType);
		}
		
		if (StructKeyExists(rc, "formConfigID")) {
			var formConfig = FormConfigService.load(rc.formConfigID);
			ent.setFormConfig(formConfig);
		}
	}

}