/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="product" {
	property ProductService;
	property SportsLeagueRegService;
	property SportsSeasonService;
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
		param name = "rc.productParam" default="";
		param name = "rc.productURLParam" default="";
		param name = "rc.productClassName" default="";
		param name = "rc.isSoldOut" default="0";
		param name = "rc.messagestatus" default="";
		param name = "rc.hasSeason" default="false";
		rc.prodtype = "sports-league-reg";
		rc.title = "Create Sports League Reg";
		rc.productTypes = ProductTypeService.list();
		rc.venueContacts = VenueContactService.list();
		rc.formConfigs = FormConfigService.list();
		
		rc.eventDate = "";
		rc.registrationEndDate = "";
		
		rc.productTypeObj = ProductTypeService.loadByParam(rc.prodtype);
		rc.productTypeID = rc.productTypeObj.getProductTypeID();
		rc.productTypeName = rc.productTypeObj.getProductTypeName();
		rc.productTypeClassName = rc.productTypeObj.getProductTypeClassName();
		rc.prices = rc.productTypeObj.getPrices();
		
		rc.seasons = SportsSeasonService.list();
		
	}
	public any function doCreate(required rc) {
		var ent = SportsLeagueRegService.new();
		
		populateAssociatedValues(rc,ent);
		SportsLeagueRegService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Product #rc.productName# is now saved.";
			rc.productURLParam = ent.getProductURLParam();
			variables.fw.redirect(action="adminconfig:sportsleaguereg.edit", querystring='prod=#rc.productURLParam#', preserve="message");
		}
		else {
			rc.message = "The Product #rc.productName# was not saved.";
			variables.fw.redirect(action="adminconfig:sportsleaguereg.create", preserve="all");	
		}
		
	}
	
	public any function edit(required rc) {
		param name = "rc.productName" default="";
		param name = "rc.productURLParam" default="";
		param name = "rc.productClassName" default="";
		param name = "rc.isSoldOut" default="0";
		param name = "rc.messagestatus" default="";
		param name = "rc.hasSeason" default="false";
		param name = "rc.selectedSeasons" default=ArrayNew(1);
		param name = "rc.valerrors" default=ArrayNew(1);
		param name = "rc.selectedVenueContacts" default=ArrayNew(1);
		
		rc.title = "Edit Sports League Registration";
		rc.venueContacts = VenueContactService.list();
		
		rc.eventDate = "";
		rc.registrationEndDate = "";
		
		if(StructKeyExists(rc, "prod")) {
			rc.thisProduct = ProductService.loadByParam(rc.prod); // id not param

			if (rc.messagestatus eq "") { // if the form has not been entered
				rc.productName = rc.thisProduct.getProductName();
				rc.productURLParam = rc.thisProduct.getProductURLParam();
				rc.productClassName = rc.thisProduct.getProductClassName();
				if(!IsNull(rc.thisProduct.getIsSoldOut())) rc.isSoldOut = rc.thisProduct.getIsSoldOut();
			}


			rc.ProductType = rc.thisProduct.getProductType();
			rc.productTypeID = rc.productType.getProductTypeID();
			rc.productTypeName = rc.productType.getProductTypeName();
			rc.hasVenueContact = rc.thisProduct.hasVenueContact();
			rc.hasSeason = rc.thisProduct.hasSeason();
			rc.seasons = SportsSeasonService.list();
			

			rc.hasFormConfig = rc.thisProduct.hasFormConfig();
			if(rc.hasFormConfig) {
				rc.selectedFormConfig = rc.thisProduct.getFormConfig();				
			}
			
			rc.prices = rc.ProductType.getPrices();
			rc.pricesForProduct = rc.thisProduct.getPrices();

			if(rc.hasVenueContact) {
				rc.selectedVenueContacts = rc.thisProduct.getVenueContacts();				
			}
			// get seasons associated with this league reg product
			// show as list, not selectable. Edit or Delete or Add New
			if(rc.hasSeason) {
				rc.selectedSeasons = rc.thisProduct.getSeasons();
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
			var ent = SportsLeagueRegService.loadByParam(rc.prod);
			populateAssociatedValues(rc,ent);
			SportsLeagueRegService.handleInsert(ent, rc);
			
			if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
			if (StructKeyExists(request, "message")) rc.message = request.message;
			if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
			
			if (rc.messageStatus eq "success") {
				rc.message = "The Product #rc.productName# is now saved.";
			}
			else {
				rc.message = "The Product #rc.productName# was not saved.";			
			}
			/*WriteOutput(
				"rc.messageStatus: " & rc.messageStatus & "<br />"
				& "rc.message: " & rc.message & "<br />"
			);
			WriteDump(ent);
			abort;*/
		}
		
		variables.fw.redirect(action="adminconfig:sportsleaguereg.edit", preserve="all");
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
				ent.addProductPrice(price);
			}
			//ent.setProductPrices(priceArray);
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
		
		if (StructKeyExists(rc, "seasonID")) {
			for(seasonItm in rc.seasonID) {
				var season = SportsSeasonService.load(seasonItm);
				ent.addSeason(season);
			}
			season.setLeagueReg(ent);
		}
	}

}