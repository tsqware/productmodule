component extends="SportsSeason" persistent="true" 
	table="conf_sportsseasonswithdivisions" datasource="devcpctproducts" joincolumn="seasonWithDivisionID" 
{
	property name="divisions" type="array" fieldtype="one-to-many"
		cfc="SportsSeasonDivision" singularname="division"
		fkcolumn="seasonWithDivisionID"
	; 
	/*	
		a season can have many divisions; a division can be within more than one season. 
		eg, Division I could be in the Fall and the Spring
	*/
}