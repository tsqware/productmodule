component persistent="true" table="tr_paymenttypes" discriminatorcolumn="paymentTypeName" datasource="devcpctproducts" 
{
	property name="paymentTypeID" ormtype="int" fieldtype="id" generator="identity";
	
	property name="paymentTypeName" insert="false" update="false";
	
	/**
	* @numeric
	* @min 0
	*/
	property name="amount";
	/**
	* @isvalid string
	* @size 5..50
	* @NoIllegalChars	
	*/
 	property name="promoCode" type="string";
 	
 	/**
	* @required true
	* @InList "deposit,payinfull"
	*/
 	property name="priceType" type="string";
 	
	property name="ProductTransaction" fieldtype="one-to-one" cfc="ProductTransaction" fkcolumn="transactionID";
}