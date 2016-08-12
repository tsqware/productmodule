component persistent="true" table="conf_sportsleagues"
{
	property name="leagueID" type="int" fieldtype="id" generator="identity";

	property name="season" fieldtype="many-to-one"
		cfc="SportsSeasonWithLeagues" 
		fkcolumn="seasonWithLeagueID";
		
	property name="divisions" type="array" fieldtype="many-to-many"
		cfc="SportsLeagueDivision" singularname="division"
		linktable="conf_link_sportsleagues_sportsdivisions" 
		fkcolumn="leagueID" inversejoincolumn="leagueDivisionID";
	
	/**
	 * @required true 
	 * @size 2..100 
	 * @validator ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars
	 **/
	property name="leagueName" type="string";
	
	/**
	 * @required true 
	 * @size 2..100 
	 * @validator ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars
	 **/
	property name="leagueParam" type="string";
	
	/**
	 * @required true 
	 * @boolean
	 **/
	property name="isSoldOut";
	
	
}