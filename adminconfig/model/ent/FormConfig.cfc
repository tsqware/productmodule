component persistent="true" table="conf_formconfigs" output="false" {
	property name="formConfigID" ormtype="int" fieldtype="id" generator="identity";
	property name="formName" type="string";
	property name="formParam" type="String";
	
	//conf
	//tra
	//rep
	property name="EmailNotifications" type="array" fieldtype="one-to-many" cfc="EmailNotification" fkcolumn="formConfigID" singularname="EmailNotification";
	property name="RequiredFields" type="array" fieldtype="many-to-many" 
		cfc="RequiredField" singularname="RequiredField" 
		linktable="conf_link_formconfigs_requiredfields" 
		fkcolumn="formConfigID" inversejoincolumn="fieldID";
	property name="PaymentTypes" fieldtype="many-to-many" type="array" 
		cfc="PaymentType" singularname="PaymentType" 
		linktable="conf_link_formconfigs_paymenttypes" 		
		fkcolumn="formConfigID" inversejoincolumn="paymentTypeID";
	property name="Product" fieldtype="one-to-one" cfc="Product" fkcolumn="productID";
	
	this.constraints = {
		formName = {required=true,unique=true,size="5..100",validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"},
		formParam = {required=true,unique=true,size="5..100",validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"}
	};
		
	public array function validate(ent=this) {
		var result = [];
		var hyrule = new Hyrule.Validator();
		var validation = hyrule.validate(this);
		result = validation.getErrors();
		return result;
	}
}