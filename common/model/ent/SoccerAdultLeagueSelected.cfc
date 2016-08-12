component persistent="true" extends="ProductSelected" table="tr_productselected_socceradultleague" joincolumn="productSelectedID" datasource="devcpctproducts" 
{
	/**
	* @display League Name
	* @required true
	* @isvalid String
	* @NoIllegalChars
	* @size 5..100
	*/
	property name="leagueName";

	/**
	* @display League Season
	* @required true
	* @isvalid String
	* @NoIllegalChars
	* @size 5..100
	*/
	property name="leagueSeason";
	
	/**
	* @isvalid Date
	*/	
	property name="leagueStartDate";

	/**
	* @isvalid Date
	*/	
	property name="leagueEndDate";

	/**
	* @numeric
	*/	
	property name="regTotal";

	/**
	* @numeric
	*/	
	property name="regBalanceDue";

	/**
	* @isvalid boolean
	*/	
	property name="agreeToTerms";
}