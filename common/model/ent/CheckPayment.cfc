component extends="Payment" persistent="true" table="tr_paymenttypes_check" joincolumn="paymentTypeID" discriminatorvalue="Check" datasource="devcpctproducts"  { 
	property name="depositDueDate" type="date" ormtype="date" ;
	
	this.constraints = {
		depositDueDate = {required=true, isvalid="date"}
	};
}