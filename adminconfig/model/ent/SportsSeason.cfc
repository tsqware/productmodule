component persistent="true" table="conf_sportsseasons" datasource="devcpctproducts" {
	property name="seasonID" type="numeric" fieldtype="id" generator="identity";
	
	property name="leagueReg" fieldtype="many-to-one" 
		cfc="SportsLeagueReg"
		fkcolumn="leagueRegID"
		hint="a League Reg can have many seasons; a Season can be associated with one League Reg";
		
	property name="prices" type="array" fieldtype="one-to-many" 
		cfc="SeasonPrice" singularname="price" 
		fkcolumn="seasonID";
		
	/**
	 * @required true 
	 * @size 2..100 
	 * @validator ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars
	 **/
	property name="seasonName" type="string";
	
	/**
	 * @required true 
	 * @size 2..100 
	 * @validator ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars
	 **/
	property name="seasonParam" type="string";
	
	/**
	 * @required true
	 * @isvalid date
	 **/
	property name="startDate" type="date";
	
	/**
	 * @required true
	 * @isvalid date
	 **/
	property name="endDate" type="date";
	
	/**
	 * @isvalid date
	 **/
	property name="earlyRegDueDate" type="date";
	
	/**
	 * @required true
	 * @isvalid date
	 **/
	property name="regDueDate" type="date";
	
}