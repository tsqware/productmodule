component persistent="true" table="tr_customers" datasource="devcpctproducts"
{
	property name="customerID" ormtype="int" fieldtype="id" generator="identity" ;
	
	/**
	* @IsRequiredCustomerField
	* @size "5..100"
	* @NoIllegalChars
	*/
	property name="firstName" type="string" ;	
	
	/**
	* @IsRequiredCustomerField
	* @size "5..100"
	* @NoIllegalChars
	*/
	property name="lastName" type="string" ;
	
	/**
	* @displayname Home Address
	* @IsRequiredCustomerField
	* @size "5..100"
	* @NoIllegalChars
	*/
	property name="hAddress" type="string" ;
	
	/**
	* @displayname Home Address Line 2
	* @size "5..100"
	* @NoIllegalChars
	*/
	property name="hAddress2" type="string" ;
	
	/**
	* @displayname Home City
	* @IsRequiredCustomerField
	* @size "5..100"
	* @NoIllegalChars
	*/
	property name="hCity" type="string" ;
	
	/**
	* @displayname Home State
	* @IsRequiredCustomerField
	* @size "2..2"
	* @NoIllegalChars
	*/
	property name="hState" type="string" ;
	
	/**
	* @displayname Home Zip Code
	* @IsRequiredCustomerField
	* @isvalid zipcode
	*/
	property name="hZip" ;
	
	/**
	* @displayname Primary Phone
	* @IsRequiredCustomerField
	* @isvalid telephone
	*/
	property name="priPhone" type="string" ;
	
	/**
	* @displayname Secondary Phone
	* @IsRequiredCustomerField
	* @isvalid telephone
	*/
	property name="secPhone" type="string" ;
	
	/**
	* @IsRequiredCustomerField
	* @isvalid email
	*/
	property name="email" type="string" ;  
  
  
	property name="ProductTransaction" fieldtype="one-to-one" cfc="ProductTransaction" fkcolumn="transactionID" ;
	
	public boolean function testValid() {
		request.message = "This field is so not valid.";
		return false;
	}
	public boolean function testValid2() {
		return false;
	}
}