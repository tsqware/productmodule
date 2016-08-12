/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="product" {
	property ProductService;
	property EventRSVPService;
	property ProductTypeService;
	property VenueContactService;
	property FormConfigService;
	property PriceService;
	property ProductPriceService;
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
		param name = "rc.productURLParam" default="";
		param name = "rc.productClassName" default="";
		param name = "rc.isSoldOut" default="0";
		param name = "rc.messagestatus" default="";
		param name="rc.eventStartDate" default = "";
		param name="rc.eventStartTime" default = "";
		param name="rc.eventEndDate" default = "";
		param name="rc.eventEndTime" default = "";
		param name="rc.registrationEndDate" default = "";
		param name="rc.registrationEndTime" default = "";

		//WriteDump(variables.fw);
		rc.title = "Create Event RSVP";
		rc.prodtype = "event-rsvp";
		rc.venueContacts = VenueContactService.list();
		
		rc.productTypeObj = ProductTypeService.loadByParam(rc.prodtype);
		rc.productTypeID = rc.productTypeObj.getProductTypeID();
		rc.productTypeName = rc.productTypeObj.getProductTypeName();
		rc.productTypeParam = rc.productTypeObj.getProductTypeParam();
		rc.productTypeClassName = rc.productTypeObj.getProductTypeClassName();
		rc.prices = rc.productTypeObj.getPrices();
	}
	public any function doCreate(required rc) {
		var ent = EventRSVPService.new();
		populateAssociatedValues(rc,ent);		
		EventRSVPService.handleInsert(ent, rc);		
		loadVarsForRedirect(rc);
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Product #rc.productName# is now saved.";
			var productURLParam = ent.getProductURLParam();
			variables.fw.redirect(action="adminconfig:eventrsvp.edit", querystring="prod=#productURLParam#", preserve="message");
		}
		else {
			rc.message = "The Product #rc.productName# was not saved.";
			variables.fw.redirect(action="adminconfig:eventrsvp.create", preserve="all");
		}
		
	}
	
	public any function edit(required rc) {
		param name = "rc.productName" default="";
		param name = "rc.productURLParam" default="";
		param name = "rc.productClassName" default="";
		param name = "rc.isSoldOut" default="0";
		param name = "rc.messagestatus" default="";
		param name="rc.eventStartDate" default = "";
		param name="rc.eventStartTime" default = "";
		param name="rc.eventEndDate" default = "";
		param name="rc.eventEndTime" default = "";
		param name="rc.registrationEndDate" default = "";
		param name="rc.registrationEndTime" default = "";
		
		rc.title = "Edit Event RSVP";
		rc.venueContacts = VenueContactService.list();
		
		if(StructKeyExists(rc, "prod")) {
			rc.thisProduct = ProductService.loadByParam(rc.prod); // id not param
			if (rc.messagestatus eq "") { // if the form has not been entered
				rc.productName = rc.thisProduct.getProductName();
				rc.productURLParam = rc.thisProduct.getProductURLParam();
				rc.productClassName = rc.thisProduct.getProductClassName();
				if(!IsNull(rc.thisProduct.getIsSoldOut())) rc.isSoldOut = rc.thisProduct.getIsSoldOut();
				rc.selectedVenueContacts = rc.thisProduct.getVenueContacts();
				
				rc.eventStartDate = DateFormat(rc.thisProduct.getEventStartDateTime(), "mm/dd/yyyy");
				rc.eventStartTime = LCase(TimeFormat(rc.thisProduct.getEventStartDateTime(), "hh:mmtt"));
				rc.eventEndDate = DateFormat(rc.thisProduct.getEventEndDateTime(), "mm/dd/yyyy");
				rc.eventEndTime = LCase(TimeFormat(rc.thisProduct.getEventEndDateTime(), "hh:mmtt"));
				rc.registrationEndDate = DateFormat(rc.thisProduct.getRegistrationEndDateTime(), "mm/dd/yyyy");
				rc.registrationEndTime = LCase(TimeFormat(rc.thisProduct.getRegistrationEndDateTime(), "hh:mmtt"));
				
			}
			
			rc.ProductType = rc.thisProduct.getProductType();
			// loadProductTypeData
			rc.productTypeID = rc.productType.getProductTypeID();
			rc.productTypeName = rc.productType.getProductTypeName();
			rc.productTypeClassName = rc.productType.getProductTypeClassName();

			rc.hasVenueContact = rc.thisProduct.hasVenueContact();

			rc.hasFormConfig = rc.thisProduct.hasFormConfig();
			if(rc.hasFormConfig) {
				rc.selectedFormConfig = rc.thisProduct.getFormConfig();				
			}
			rc.prices = rc.ProductType.getPrices();
			rc.pricesForProduct = rc.thisProduct.getPrices();

			// venue contacts - based on form selection
			if(rc.hasVenueContact) {
				rc.selectedVenueContacts = rc.thisProduct.getVenueContacts();				
			}		
		}
		else {
			rc.messagestatus = "notfound";
			rc.message = "Product could not be found.";
		}
	}
	public any function doEdit(required rc) {
		if(!StructKeyExists(rc, "prod")) {
			rc.messagestatus = "notfound";
			rc.message = "Product could not be found.";
		}
		else {
			var ent = EventRSVPService.loadByParam(rc.prod);			
			populateAssociatedValues(rc,ent);
			EventRSVPService.handleInsert(ent, rc);			
			loadVarsForRedirect(rc);

			if (rc.messageStatus eq "success") {
				rc.message = "The Product #rc.productName# is now saved.";
			}
			else {
				rc.message = "The Product #rc.productName# was not saved.";			
			}
		}
		
		variables.fw.redirect(action="adminconfig:eventrsvp.edit", preserve="all");
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}

	private function populateAssociatedValues(rc,ent) {
		var venueContactArray = [];
		var priceArray = [];
		
		if(StructKeyExists(rc, "contactID")) {
			for(contact in rc.contactID) {
				var venueContact = VenueContactService.load(contact);
				ArrayAppend(venueContactArray, venueContact);
			}
			ent.setVenueContacts(venueContactArray);
		}
		
		if(StructKeyExists(rc, "priceID")) {
			for(priceItm in rc.priceID) {
				var price = ProductPriceService.load(priceItm);
				ArrayAppend(priceArray, price);
			}
			ent.setPrices(priceArray);
		}
		
		if (StructKeyExists(rc, "productTypeID")) {
			var productType = ProductTypeService.load(rc.productTypeID);
			ent.setProductType(productType);
		}
		
		if (StructKeyExists(rc, "formConfigID")) {
			var formConfig = FormConfigService.load(rc.formConfigID);
			ent.setFormConfig(formConfig);
			formConfig.setProduct(ent);
		}
	}

}