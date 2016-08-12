component persistent="true" table="conf_pricetypes" output="false" {

	property name="priceTypeID" ormtype="int" fieldtype="id" generator="identity";
	property name="priceTypeName" type="string";
	property name="priceTypeParam" type="string";
	property name="priceTypeClassName" type="string";
	
	property name="Prices" cfc="Price" singularname="Price" fieldtype="one-to-many" type="array" fkcolumn="priceTypeID";
	
	this.constraints = {
		priceTypeName = {required=true,size="2..100",validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"},
		priceTypeParam = {required=true,size="2..50",validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"},
		priceTypeClassName = {required=true,size="2..100",validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"}
	};
}