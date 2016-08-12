/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	
	property SeasonPriceService;
	property PriceTypeService;
	property SportsSeasonService;
	property ProductTypeService;
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
		rc.title="New Season Price";
		param name = "rc.priceName" default="";
		param name = "rc.priceParam" default="";
		param name = "rc.priceAmount" default="";
		param name = "rc.messagestatus" default="";
		
		rc.pricetype = "season";
		rc.seasons = SportsSeasonService.list();
		rc.ProductTypes = ProductTypeService.list();
		if (StructKeyExists(rc, "pricetype")) {
			// get the price type name associated with the pricetype param
			var thisPriceType = PriceTypeService.loadByParam(rc.pricetype);
			if (IsBoolean(thisPriceType) && !thisPriceType) {
				rc.messagestatus = "notfound";
				rc.message = "The page could not be found 1.";
			}
			else {
				rc.priceTypeID = thisPriceType.getPriceTypeID();
				rc.priceTypeName = thisPriceType.getPriceTypeName();
				if (StructKeyExists(rc, "sea")) {
					rc.thisSeason = SportsSeasonService.load(rc.sea);
					if(!IsBoolean(rc.thisSeason)) {						
						loadSeasonData(rc);
						if(rc.thisSeason.hasLeagueReg()) {
							rc.hasProduct = true;
							rc.prod = rc.thisSeason.getLeagueReg().getProductURLParam();
							loadAssociatedProduct(rc, "prod");
						}					
					}
					else {
						rc.messagestatus = "notfound";
						rc.message = "Season Price must be associated with a Season.";
					}
				}
				else {
					rc.messagestatus = "notfound";
					rc.message = "Season Price must be associated with a Season.";
				}		
			}
		}
		else {
			// alert that the page cannot be found
			rc.messagestatus = "notfound";
			rc.message = "The page could not be found 2.";
		}
	}
	public any function doCreate(required rc) {
		var ent = SeasonPriceService.new();
		
		if (StructKeyExists(rc, "priceTypeID")) {				
			var ptEnt = PriceTypeService.load(rc.priceTypeID);
			ent.setPriceType(ptEnt);
		}
		if (StructKeyExists(rc, "seasonID")) {
			var season = SportsSeasonService.load(rc.seasonID);
			ent.setSeason(season);
		}

		SeasonPriceService.handleInsert(ent, rc);
		
		loadVarsForRedirect(rc);
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Season Price <b>#rc.priceName#</b> was saved.";
			var priceID = ent.getPriceID();
			variables.fw.redirect(action="adminconfig:seasonprice.edit", querystring="seaprice=#priceID#", preserve="messagestatus,message,valerrors");
		}
		else {
			rc.message = "The Season Price was not saved.";
			variables.fw.redirect(action="adminconfig:seasonprice.create", querystring="sea=#rc.sea#", preserve="all");	
		}
		
	}	
	
	public any function edit(required rc) {
		param name = "rc.priceName" default="";
		param name = "rc.priceParam" default="";
		param name = "rc.priceAmount" default="";
		param name = "rc.messagestatus" default="";
		rc.title = "Edit Season Price";
		
		if (StructKeyExists(rc, "seaprice")) {
			rc.thisSeasonPrice = SeasonPriceService.load(rc.seaprice); // id not param
			if (!IsBoolean(rc.thisSeasonPrice)) {
				rc.priceName = rc.thisSeasonPrice.getPriceName();
				rc.priceParam = rc.thisSeasonPrice.getPriceParam();
				rc.priceAmount = rc.thisSeasonPrice.getPriceAmount();
				rc.priceType = rc.thisSeasonPrice.getPriceType();
				rc.priceTypeID = rc.priceType.getPriceTypeID();
				rc.priceTypeName = rc.priceType.getPriceTypeName();
				
				rc.hasSeason = rc.thisSeasonPrice.hasSeason();
				rc.seasons = SportsSeasonService.list();
				
				rc.thisSeason = rc.thisSeasonPrice.getSeason();
				rc.seasonID = rc.thisSeason.getSeasonID();
				//WriteDump(rc.thisSeason.hasLeagueReg()); abort;
				loadSeasonData(rc);
				if(rc.thisSeason.hasLeagueReg()) {
					rc.hasProduct = true;
					rc.prod = rc.thisSeason.getLeagueReg().getProductURLParam();
					//WriteDump(rc.prod);
					loadAssociatedProduct(rc, "prod");
				}
				//WriteDump(var=rc, abort=true);
			}
			else {
				rc.messagestatus = "notfound";
				rc.message = "Season Price could not be found.";
			}			
		}
		else {
			rc.messagestatus = "notfound";
			rc.message = "Season Price could not be found.";
		}
	}
	public any function doEdit(required rc) {
		WriteDump(var=rc, abort=false);
		if (StructKeyExists(rc, "seaprice")) {
			var ent = SeasonPriceService.load(rc.seaprice);

			if (StructKeyExists(rc, "seasonID")) {
				var season = SportsSeasonService.load(rc.seasonID);	
				ent.setSeason(season);
			}
			//WriteDump(ent);
			//abort;
			SeasonPriceService.handleInsert(ent, rc);
			
			loadVarsForRedirect(rc);
			
			if (rc.messageStatus eq "success") {
				rc.message = "The Season Price <b>#rc.priceName#</b> was saved.";
				variables.fw.redirect(action="adminconfig:seasonprice.edit", querystring="seaprice=#rc.seaprice#", preserve="messagestatus,message,valerrors");
			}
			else {
				rc.message = "The Season Price was not saved.";	
				variables.fw.redirect(action="adminconfig:seasonprice.edit", querystring="seaprice=#rc.seaprice#", preserve="all");		
			}					

		}
		else {
			rc.messagestatus = "notfound";
			rc.message = "Season Price could not be found.";
		}
		
		
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
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

}