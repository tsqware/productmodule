/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	property ProductService;
	property SportsLeagueRegService;
	property SportsSeasonService;
	property SportsSeasonWithLeaguesService;
	property SportsSeasonWithDivisionsService;
	property SportsLeagueService;
	property SportsSeasonDivisionService;
	property ProductTypeService;
	property VenueContactService;
	property FormConfigService;
	property PriceService;
	property ProductPriceService;
	property PriceTypeService;
	property SeasonPriceService;

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
		param name = "rc.seasonName" default="";
		param name = "rc.seasonParam" default="";
		param name = "rc.startDate" default="";
		param name = "rc.endDate" default="";
		param name = "rc.earlyRegDueDate" default="";
		param name = "rc.regDueDate" default="";
		param name = "rc.hasLeague" default="false";
		param name = "rc.hasDivision" default="false";
		param name = "rc.leagueStructure" default="";
		param name = "rc.messagestatus" default="";
		param name = "rc.divisions" default=[];

		rc.title = "Create New Sports Season";
		if (!StructKeyExists(rc, "prod")) {
			rc.message = "Unable to create Sports Season - not associated with a Product";
		}
		else {
			loadAssociatedProduct(rc, 'prod');
			rc.venueContacts = VenueContactService.list();
			rc.formConfigs = FormConfigService.list();
			rc.prices = SeasonPriceService.list();
			
			rc.seasons = SportsSeasonService.list();
			rc.leagues = SportsLeagueService.list();
			rc.leagues = SportsSeasonDivisionService.list();
			rc.selectedLeagues = [];
			rc.selectedDivisions = [];
			rc.hasLeague = 		IsDefined("rc.leagueStructure") // does the league structure radio button have a value?
								&& (rc.leagueStructure == "League" || rc.leagueStructure == "Division") // the value equals league or division, must be available when toggled
								&& IsDefined("rc.leagueID"); // does the league id exist

			rc.hasDivision = 	IsDefined("rc.leagueStructure") 
								&& (rc.leagueStructure == "League" || rc.leagueStructure == "Division") 
								&& IsDefined("rc.divisionID");
			if(rc.hasLeague) {
				for(sl in rc.leagueID) {
					var lgObj = SportsLeagueService.load(sl);
					if(!IsBoolean(lgObj)) {
						ArrayAppend(selectedLeagues, lgObj);
					}
				}
			}
			if(rc.hasDivision) {
				for(sd in rc.divisionID) {
					var dvObj = SportsDivisionService.load(sd);
					if(!IsBoolean(dvObj)) {
						ArrayAppend(selectedDivisions, dvObj);
					}
				}
			}
			rc.formAction = {
				action= 'adminconfig:sportsseason.doCreate'
			};
		}
				
	}
	public any function doCreate(required rc) {
		var ent = "";
		var svc = "";
		var sectionLink = "";
		
		//WriteDump(rc);
		
		if(StructKeyExists(rc, "leagueStructure") && rc.leagueStructure == "League") {
			svc = SportsSeasonWithLeaguesService;
			sectionLink = "sportsseasonwithleague";	
		}
		else if(StructKeyExists(rc, "leagueStructure") && rc.leagueStructure == "Division") {
			svc = SportsSeasonWithDivisionsService;
			sectionLink = "sportsseasonwithdivision";
		}
		else {
			//svc = SportsSeasonService;
			rc.message = "League Structure is required.";
			rc.messageStatus = "notfound";
			rc.valerrors = [];
			variables.fw.redirect(action="adminconfig:sportsseason.create", preserve="all");
		}

		ent = svc.new();
		if (StructKeyExists(rc, 'prod')) {
			loadAssociatedProduct(rc, "prod");
		}
		populateAssociatedValues(rc,ent);
		svc.handleInsert(ent, rc);		
		loadVarsForRedirect(rc);
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Season #rc.seasonName# is now saved.";
			rc.seasonID = ent.getSeasonID();
			variables.fw.redirect(action="adminconfig:#sectionLink#.edit", querystring='sea=#rc.seasonID#', preserve="messagestatus, message, valerrors");
		}
		else {
			rc.message = "The Season was not saved.";	
			variables.fw.redirect(action="adminconfig:sportsseason.create", preserve="all");		
		}
		
	}
	
	public any function edit(required rc) {
		// must be either sportsseasonwithleague or sportsseasonwithdivision
		rc.title = "Edit Sports Season";			
		rc.messagestatus = "notfound";
		rc.message = "Season could not be found.";
		param name="rc.valerrors" default = [];
				
	}
	public any function doEdit(required rc) {
		variables.fw.redirect(action="adminconfig:sportsseason.edit", preserve="all");
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}
	
	private function populateAssociatedValues(rc,ent) {
		var leagueArray = [];
		var priceArray = [];
		var isSeasonWithLeagues = IsInstanceOf(ent, "ProductModule.adminconfig.model.ent.SportsSeasonWithLeagues");
		//WriteDump(var=ent);
		//WriteDump( isSeasonWithLeagues );
		//abort;
		if(isSeasonWithLeagues && StructKeyExists(rc, "leagueStructure") && rc.leagueStructure == "League") {
			if(StructKeyExists(rc, "leagueID")) {
				if(methodExists(ent, "hasLeague")) {
					ent.setLeagues(JavaCast('null', ''));
				}
				//WriteOutput(rc.leagueID);
				if(IsDefined("rc.leagueID") && Len(rc.leagueID) > 0) {
					for(itm in rc.leagueID) {
						lgObj = SportsLeagueService.load(itm);
						ArrayAppend(leagueArray, lgObj);
					}
					ent.setLeagues(leagueArray);
					for(lg in ent.getLeagues()) {
						//WriteDump(lg);
						lg.setSeason(ent);
					}
				}
			}
			
		}
		
		if (StructKeyExists(rc, "productID")) {
			var product = ProductService.load(rc.productID);
			ent.setLeagueReg(product);
			product.addSeason(ent);
		}
		
		if(StructKeyExists(rc, "contactID")) {
			for(contact in rc.contactID) {
				var venueContact = VenueContactService.load(contact);
				ArrayAppend(venueContactArray, venueContact);
			}
			ent.setVenueContacts(venueContactArray);
		}
		
		if(StructKeyExists(rc, "priceID")) {
			if(methodExists(ent, "hasPrice")) {
				ent.setPrices(JavaCast('null', ''));
			}
			for(priceItm in rc.priceID) {
				var price = SeasonPriceService.load(priceItm);
				ent.addPrice(price);
			}
			//ent.setProductPrices(priceArray);
		}
		
		if (StructKeyExists(rc, "formConfigID")) {
			var formConfig = FormConfigService.load(rc.formConfigID);
			ent.setFormConfig(formConfig);
			formConfig.setProduct(ent);
		}
	}
	
	private boolean function methodExists(obj, meth) {
		var meta = getMetaData(obj);
		//WriteDump(meta);
		for(f in meta.functions) {
			//WriteOutput("name" & f.name & "<br>");
			//WriteOutput("method" & meth & "<br>");
			if(f.name == meth) {
				return true;
			}			
		}
		return false;
	}

}