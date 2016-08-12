component extends="SportsDivision" persistent="true" table="conf_sportsdivisionsleague"
	datasource="devcpctproducts" joincolumn="leagueDivisionID"  
		
{
	property name="league" fieldtype="many-to-one"
		cfc="SportsLeague" fkcolumn="leagueID" ;

	/*property name="leagues" type="array" fieldtype="many-to-many"
		cfc="SportsLeague" singularname="league"
		linktable="conf_link_sportsleagues_sportsdivisions" 
		fkcolumn="leagueDivisionID" inversejoincolumn="leagueID";*/
}