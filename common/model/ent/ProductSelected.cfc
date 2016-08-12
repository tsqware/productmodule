component persistent="true" table="tr_productselected" datasource="devcpctproducts"
{
	property name="productSelectedID" type="numeric" ormtype="int" fieldtype="id" generator="identity";
	
	/**
	* @required true
	* @isvalid string
	* @size "5..100"
	* @NoIllegalChars
	*/
	property name="productName" type="string";
	
	/**
	* @required true
	* @isvalid string
	* @size "5..50"
	* @NoIllegalChars
	*/
	property name="productURLParam" type="string";

	/**
	* @required true
	* @isvalid string
	* @size "5..50"
	* @NoIllegalChars
	*/
	property name="productClassParam" type="string";
	
	/**
	* @required true
	* @isvalid string
	* @size "5..100"
	* @NoIllegalChars
	*/
	property name="productTypeName" type="string";
	
	/**
	* @isvalid string
	* @size "5..300"
	* @NoIllegalChars
	*/
	property name="comments" type="string";
	
	property name="ProductTransaction" fieldtype="one-to-one" cfc="ProductTransaction" fkcolumn="transactionID" ;
}