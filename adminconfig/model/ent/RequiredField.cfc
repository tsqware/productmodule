component persistent="true" table="conf_requiredfields" datasource="devcpctproducts" {
	property name="fieldID" ormtype="int" fieldtype="id" generator="identity" ;
	
	property name="fieldName" type="String" ;
	property name="fieldParam" type="String" ;
	
	property name="fieldType" type="String" ;
	
	this.constraints = {
		fieldName = {required=true,size="5..100"},
		fieldParam = {required=true,size="4..50"}
	};
	
	
}