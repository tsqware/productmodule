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
	property SportsLeagueService;
	property SeasonPriceService;
	property ProductTypeService;
	property VenueContactService;
	property FormConfigService;
	property PriceService;
	property ProductPriceService;
	property PriceTypeService;
	property SportsSeasonWithLeaguesService;
	
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
		param name = "rc.hasProduct" default="false";
		param name = "rc.messagestatus" default="";
		param name="rc.valerrors" default = [];

		rc.title = "Create New Sports Season";
		rc.prodtype = "sports-league-reg";
		rc.venueContacts = VenueContactService.list();
		
		rc.hasProduct = StructKeyExists(rc, "prod");
		if (!rc.hasProduct) {
			rc.messagestatus = "notfound";
			rc.message = "Season must be associated with a product.";
		}
		else {
			loadAssociatedProduct(rc,"prod");
		}
		
		
	}
	public any function doCreate(required rc) {
		var ent = SportsSeasonWithLeaguesService.new();	
		populateAssociatedValues(rc,ent);		
		SportsSeasonWithLeaguesService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Season #rc.seasonName# is now saved.";
		}
		else {
			rc.message = "The Season was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:sportsseasonwithleague.create", preserve="all");
	}
	
	public any function edit(required rc) {
		param name = "rc.seasonName" default="";
		param name = "rc.seasonParam" default="";
		param name = "rc.startDate" default="";
		param name = "rc.endDate" default="";
		param name = "rc.earlyRegDueDate" default="";
		param name = "rc.regDueDate" default="";
		param name = "rc.messagestatus" default="";
		param name = "rc.leagueStructure" default="";
		param name = "rc.prices" default="#ArrayNew(1)#";
		param name = "rc.valerrors" default="#ArrayNew(1)#";

		rc.title = "Edit Sports Season";
		
		
		/*rc.productTypes = ProductTypeService.list();
		rc.venueContacts = VenueContactService.list();
		rc.formConfigs = FormConfigService.list();*/
		
		if(StructKeyExists(rc, "sea")) {
			rc.thisSeason = SportsSeasonWithLeaguesService.load(rc.sea); // id not param
			if(!IsBoolean(rc.thisSeason)) {
				rc.seasonName = rc.thisSeason.getSeasonName();
				rc.seasonParam = rc.thisSeason.getSeasonParam();
				rc.startDate = rc.thisSeason.getStartDate();
				rc.endDate = rc.thisSeason.getEndDate();
				if (!IsNull(rc.thisSeason.getEarlyRegDueDate()))
					rc.earlyRegDueDate = rc.thisSeason.getEarlyRegDueDate();
				else
					rc.earlyRegDueDate = '';
				rc.regDueDate = rc.thisSeason.getRegDueDate();
				
				rc.hasLeague = methodExists(rc.thisSeason, "hasLeague");
				rc.hasPrice = rc.thisSeason.hasPrice();
				rc.products = SportsLeagueRegService.list();
				rc.hasProduct = rc.thisSeason.hasLeagueReg();				

				rc.leagues = SportsLeagueService.list();
				if(rc.hasLeague) rc.selectedLeagues = rc.thisSeason.getLeagues();
				
				rc.prices = SeasonPriceService.list();
				if(rc.hasPrice) {
					rc.prices = SeasonPriceService.list();
					rc.pricesForSeason = rc.thisSeason.getPrices();
				}

				if(rc.hasProduct) {
					rc.productID = rc.thisSeason.getLeagueReg().getProductID();
					rc.prod = rc.thisSeason.getLeagueReg().getProductURLParam();
					loadAssociatedProduct(rc,'prod');
				}				
			}
			else {
				rc.messagestatus = "notfound";
				rc.message = "Season could not be found.";
			}
		}
		else {
			rc.messagestatus = "notfound";
			rc.message = "Season could not be found.";
		}
	}
	public any function doEdit(required rc) {
		if(!StructKeyExists(rc, "sea")) {
			rc.messagestatus = "notfound";
			rc.message = "League Season could not be found.";
		}
		else {
			var ent = SportsSeasonWithLeaguesService.load(rc.sea);
			populateAssociatedValues(rc,ent);
			SportsSeasonWithLeaguesService.handleInsert(ent, rc);
			loadVarsForRedirect(rc);
			
			if (rc.messageStatus eq "success") {
				rc.message = "The Season #rc.seasonName# is now saved.";
				variables.fw.redirect(action="adminconfig:sportsseasonwithleague.edit", querystring="sea=#rc.sea#", preserve="message,messageStatus,valerrors,sea");
			}
			else {
				rc.message = "The Season #rc.seasonName# was not saved.";
				variables.fw.redirect(action="adminconfig:sportsseasonwithleague.edit", querystring="sea=#rc.sea#", preserve="all");		
			}
		}		
		
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}
	
	private function populateAssociatedValues(rc,ent) {
		if(StructKeyExists(rc, "productID")) {
			prObj = SportsLeagueRegService.load(rc.productID);
			ent.setLeagueReg(prObj);
		}
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