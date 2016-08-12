component persistent="true" table="conf_paymenttypes" datasource="devcpctproducts" {
	property name="paymentTypeID" ormtype="int" fieldtype="id" generator="identity";

	property name="FormConfigs" fieldtype="many-to-many" type="array" 
		cfc="FormConfig" singularname="FormConfig" 
		linktable="conf_link_formconfigs_paymenttypes" 		
		fkcolumn="paymentTypeID" inversejoincolumn="formConfigID";
	
	property name="paymentTypeName" type="string";
	property name="paymentTypeParam" type="string";

	
	this.constraints = {
		paymentTypeName = {required=true,size="3..100"},
		paymentTypeParam = {required=true,size="3..50"}
	};
	
	public array function validate(ent=this) {
		WriteDump(this);
		var result = [];
		var hyrule = new Hyrule.Validator();
		
		result = hyrule.validate(ent).getErrors();
		
		return result;
	}
}