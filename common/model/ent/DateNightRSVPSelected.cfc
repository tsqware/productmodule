component persistent="true" extends="ProductSelected" table="tr_productselected_datenightrsvp" joincolumn="productSelectedID" datasource="devcpctproducts" 
{
	/**
	* @isvalid date
	*/
	property name="eventStart" type="date" sqltype="datetime"  ;

	/**
	* @isvalid date
	*/
	property name="eventEnd" type="date";
	
	/**
	* @method validateNumChildren
	* @numeric
	* @min 0
	*/	
	property name="numberOfChildrenOver5" default="0";
	
	/**
	* @numeric
	* @min 0
	*/	
	property name="numberOfChildrenUnder5" default="0";
	
	public function validateNumChildren() {
		var isvalid = true;
		if(getNumberOfChildrenOver5() <=0 && getNumberOfChildrenUnder5() <= 0) {
			isvalid = false;
		}
		return isvalid;
	}
}