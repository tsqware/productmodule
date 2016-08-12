/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	property SportsSeasonDivisionService;
	property SportsSeasonService;
	property ProductService;
	
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
		setScreenDefaults(rc);
		rc.title = "New Sports Season Division";
		if(!StructKeyExists(rc, "sea")) {
			rc.messagestatus = "notfound";
			rc.message = "Season Division must be associated with a Season.";
		}
		else {				
			rc.thisSeason = SportsSeasonService.load(rc.sea);
			loadLinkedData(rc);		
		}			
	}
	public any function doCreate(required rc) {
		if(!StructKeyExists(rc, "sea")) {
			rc.messagestatus = "notfound";
			rc.message = "Season Division must be associated with a Season.";
		}
		else {				
			rc.thisSeason = SportsSeasonService.load(rc.sea);
			loadLinkedData(rc);

			var ent = SportsSeasonDivisionService.new();
			populateAssociatedValues(rc,ent);

			SportsSeasonDivisionService.handleInsert(ent, rc);		
			loadVarsForRedirect(rc);
			if (rc.messageStatus eq "success") {
				rc.message = "The Division #rc.divisionName# is now saved.";
				var divisionID = ent.getDivisionID();
				variables.fw.redirect(action="adminconfig:sportsseasondivision.edit", querystring="div=#divisionID#", preserve="messageStatus,message,valerrors");

			}
			else {
				rc.message = "The Division was not saved.";
				variables.fw.redirect(action="adminconfig:sportsseasondivision.create", querystring="sea=#rc.sea#", preserve="all");	
			}
		}		
	}
	
	public any function edit(required rc) {
		setScreenDefaults(rc);		
		rc.title = "Edit Sports Season Division";
		
		if(StructKeyExists(rc, "div")) {
			rc.thisDivision = SportsSeasonDivisionService.load(rc.div); // id not param
			rc.divisionName = rc.thisDivision.getDivisionName();
			rc.divisionParam = rc.thisDivision.getDivisionParam();

			rc.hasSeason = rc.thisDivision.hasSeason();
			if(rc.hasSeason) {
				rc.thisSeason = rc.thisDivision.getSeason();
				loadLinkedData(rc);
			}
		}
		else {
			rc.messagestatus = "notfound";
			rc.message = "Division could not be found.";
		}
	}

	
	public any function doEdit(required rc) {
		if(!StructKeyExists(rc, "div")) {
			rc.messagestatus = "notfound";
			rc.message = "Division could not be found.";
		}
		else {
			var ent = SportsSeasonDivisionService.load(rc.div);
			populateAssociatedValues(rc,ent);			
			SportsLeagueDivisionService.handleInsert(ent, rc);			
			loadVarsForRedirect(rc);
			if (rc.messageStatus eq "success") {
				rc.message = "The Division #rc.divisionName# is now saved.";
				variables.fw.redirect(action="adminconfig:sportsleaguedivision.edit", querystring="div=#rc.div#", preserve="messageStatus,message,valerrors");
			}
			else {
				rc.message = "The Division was not saved.";	
				variables.fw.redirect(action="adminconfig:sportsleaguedivision.edit", preserve="all");		
			}
		}		
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}


	private void function setScreenDefaults(rc) {
		param name = "rc.divisionName" default="";
		param name = "rc.divisionParam" default="";
		param name = "rc.messagestatus" default="";
		param name = "rc.valerrors" default=[];
		param name = "rc.hasLeague" default=false;
	}

	private void function loadLinkedData(rc) {
		if(!IsBoolean(rc.thisSeason)) {				
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
	private void function loadLeagueData(rc) {
		var league = rc.thisLeague;
		rc.hasLeague = true;
		rc.leagueID = league.getLeagueID();
		rc.leagueName = league.getLeagueName();
		rc.leagueLink = {
			action = "adminconfig:sportsleague.edit",
			querystring = "lg=#league.getLeagueID()#"
		};
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
	
	private function populateAssociatedValues(rc,ent) {
		var leagueArray = [];
		
		if(StructKeyExists(rc, "leagueID")) {			
			var league = SportsLeagueService.load(rc.leagueID);
			ent.setLeague(league);
			//WriteDump(league.hasDivision(ent));
			if(!league.hasDivision(ent)) {
				league.addDivision(ent);
			}
		}
		if(StructKeyExists(rc, "seasonID")) {			
			var season = SportsSeasonService.load(rc.seasonID);
			ent.setSeason(season);
			//WriteDump(league.hasDivision(ent));
			/*if(!league.hasDivision(ent)) {
				league.addDivision(ent);
			}*/
		}
	}
}