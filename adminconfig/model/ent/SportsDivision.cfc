component persistent="true" table="conf_sportsdivisions"
{
	property name="divisionID" type="int" fieldtype="id" generator="identity";

	/*
	property name="league" fieldtype="many-to-one"
		cfc="SportsLeague" fkcolumn="leagueID" ;
	*/
	
	/**
	 * @required true 
	 * @size 2..100 
	 * @validator ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars
	 **/
	property name="divisionName" type="string";
	
	/**
	 * @required true 
	 * @size 2..50
	 * @validator ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars
	 **/
	property name="divisionParam" type="string";

}