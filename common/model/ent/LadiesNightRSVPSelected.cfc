component persistent="true" extends="ProductSelected" table="tr_productselected_ladiesnightrsvp" joincolumn="productSelectedID" datasource="devcpctproducts" 
{
	/**
	* @isvalid date
	*/
	property name="eventStart" type="date" sqltype="datetime";

	/**
	* @isvalid date
	*/
	property name="eventEnd" type="date";
	
	/**
	* @size "5..100"
	* @NoIllegalChars
	*/	
	property name="guestFirstName";
	
	/**
	* @size "5..100"
	* @NoIllegalChars
	*/	
	property name="guestLastName";
	
	/**
	* @size "5..100"
	* @Email
	*/	
	property name="guestEmail";
}