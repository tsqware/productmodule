component persistent="true" table="tr_transactions" datasource="devcpctproducts"
{
	property name="transactionID" ormtype="int" fieldtype="id" generator="identity";
	
	property name="confirmationNum" generated="insert" update="false" ;
	
	/**
	* @required true
	* @isvalid date
	*/
	property name="transactionDate" type="date" ormtype="timestamp";
	
	/**
	* @isvalid date
	*/
	property name="processDate" type="date" ormtype="timestamp";
	
	/**
	* @inlist "pending,approved,declined"
	* @You have entered an invalid status.
	*/
	property name="transactionStatus" type="string" default="pending" ;
	
	property name="adminUserName" column="processedBy";
		
	property name="Customer" cfc="Customer" fieldtype="one-to-one" mappedby="ProductTransaction";
	property name="Payment" cfc="Payment" fieldtype="one-to-one" mappedby="ProductTransaction";
	property name="ProductSelected" cfc="ProductSelected" fieldtype="one-to-one" mappedby="ProductTransaction";
	
}