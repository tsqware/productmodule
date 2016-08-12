component extends="SportsDivision" persistent="true" table="conf_sportsdivisionsseason"
	datasource="devcpctproducts" joincolumn="seasonDivisionID" 
		
{
	property name="season" fieldtype="many-to-one"
		cfc="SportsSeasonWithDivisions" fkcolumn="seasonWithDivisionID";
}