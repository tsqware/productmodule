component extends="Product" persistent="true" 
	table="conf_products_sportsleaguereg" 
	datasource="devcpctproducts" 
	joincolumn="leagueRegID"  {	

	property name="seasons" type="array" fieldtype="one-to-many"
		cfc="SportsSeason" singularname="season" 
		fkcolumn="leagueRegID" 
		hint="a League Reg can have many seasons; a Season can be associated with only one League Reg";
		
}