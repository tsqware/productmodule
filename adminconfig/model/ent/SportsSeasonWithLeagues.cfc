component extends="SportsSeason" persistent="true" 
	table="conf_sportsseasonswithleagues" datasource="devcpctproducts" 
	joincolumn="seasonWithLeagueID" 
{
	property name="leagues" type="array" fieldtype="one-to-many"
		cfc="SportsLeague" singularname="league"
		fkcolumn="seasonWithLeagueID"
		hint="a season can have many leagues; a league can have only one season."
	;
}