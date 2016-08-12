/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	property ProductService;
	property SportsLeagueService;
	property SportsLeagueDivisionService;
	property SportsLeagueRegService;
	property SportsSeasonService;
	property SportsSeasonWithLeaguesService;
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
		rc.title = "Create Sports League";
		
		if(!StructKeyExists(rc, "sea")) {
			rc.messagestatus = "notfound";
			rc.message = "Sports League must be associated with a Season";
		}
		else {
			setScreenDefaults(rc);
			rc.thisSeason = SportsSeasonService.load(rc.sea);
			if(!IsBoolean(rc.thisSeason)) {
				rc.hasSeason = true;
				loadSeasonData(rc);
				rc.hasProduct = rc.thisSeason.hasLeagueReg();
				if (rc.hasProduct) {
					rc.prod = rc.thisSeason.getLeagueReg().getProductURLParam();
					loadAssociatedProduct(rc, "prod");
				}
			}
		}		
	}
	public any function doCreate(required rc) {
		var ent = SportsLeagueService.new();		
		populateAssociatedValues(rc,ent);
		SportsLeagueService.handleInsert(ent, rc);
		loadVarsForRedirect(rc);
		
		if (rc.messageStatus eq "success") {
			rc.message = "The League #rc.leagueName# is now saved.";
			var leagueID = ent.getLeagueID();
			variables.fw.redirect(action="adminconfig:sportsleague.edit", querystring="lg=#leagueID#", preserve="message,messageStatus,valerrors");
		}
		else {
			rc.message = "The League was not saved.";
			variables.fw.redirect(action="adminconfig:sportsleague.create", preserve="all");	
		}
	}
	
	public any function edit(required rc) {
		rc.title = "Edit Sports League";
		rc.prodtype = "sports-league-reg";
		
		if(StructKeyExists(rc, "lg")) {
			setScreenDefaults(rc);	
			rc.thisLeague = SportsLeagueService.load(rc.lg); // id not param
			if (rc.messagestatus eq "") {
				rc.leagueName = rc.thisLeague.getLeagueName();
				rc.LeagueParam = rc.thisLeague.getLeagueParam();
				if(!IsNull(rc.thisLeague.getIsSoldOut())) rc.isSoldOut = rc.thisLeague.getIsSoldOut();
			}
			rc.hasSeason = rc.thisLeague.hasSeason();			
			if(rc.thisLeague.hasDivision()) {
				rc.divisionsForLeague = rc.thisLeague.getDivisions();
			}
			if(rc.hasSeason) {
				rc.thisSeason = rc.thisLeague.getSeason();
				loadSeasonData(rc);
				rc.hasProduct = rc.thisSeason.hasLeagueReg();
				if (rc.hasProduct) {
					rc.prod = rc.thisSeason.getLeagueReg().getProductURLParam();
					loadAssociatedProduct(rc, "prod");
				}
			}			
		}
		else {
			rc.messagestatus = "notfound";
			rc.message = "League could not be found.";
		}
	}
	public any function doEdit(required rc) {
		if(!StructKeyExists(rc, "lg")) {
			rc.messagestatus = "notfound";
			rc.message = "League could not be found.";
		}
		else {
			var ent = SportsLeagueService.load(rc.lg);		
			populateAssociatedValues(rc,ent);
			SportsLeagueService.handleInsert(ent, rc);			
			loadVarsForRedirect(rc);
			
			if (rc.messageStatus eq "success") {
				rc.message = "The League #rc.leagueName# is now saved.";
				variables.fw.redirect(action="adminconfig:sportsleague.edit", querystring="lg=#lg#", preserve="messagStatus,message,valerrors");
			}
			else {
				rc.message = "The League was not saved.";
				variables.fw.redirect(action="adminconfig:sportsleague.edit", querystring="lg=#lg#", preserve="all");			
			}
		}
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}
	private void function setScreenDefaults(rc) {
		param name = "rc.leagueName" default="";
		param name = "rc.leagueParam" default="";
		param name = "rc.isSoldOut" default="0";
		param name = "rc.messagestatus" default="";
		param name = "rc.divisions" default="#ArrayNew(1)#";
		param name = "rc.hasSeason" default=false;
		param name = "rc.hasProduct" default=false;
	}
	private void function loadSeasonData(rc) {
		var seasonType = "";
		var season = rc.thisSeason;
		rc.seasonID = season.getSeasonID();
		seasonType = getSeasonType(season);
		rc.seasonName = season.getSeasonName();
		rc.seasonLink = {
			action = "adminconfig:#seasonType#.edit",
			querystring = "sea=#rc.seasonID#"
		};
	}
	private string function getSeasonType(season) {
		var seasontype = "";
		if(IsInstanceOf(season, "cpctroot.productmodule.adminconfig.model.ent.SportsSeasonWithLeagues")) {
			seasontype = "sportsseasonwithleague";
		}
		else if(IsInstanceOf(season, "cpctroot.productmodule.adminconfig.model.ent.SportsSeasonWithDivisions")) {
			seasontype = "sportsseasonwithdivision";
		}
		return seasontype;
	}
	private function populateAssociatedValues(rc,ent) {
		var venueContactArray = [];
		var priceArray = [];
		
		if (StructKeyExists(rc, "seasonID")) {
			var season = SportsSeasonWithLeaguesService.load(rc.seasonID);
			ent.setSeason(season);
		}

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
	}

}