component persistent="true" table="conf_producttypes" datasource="devcpctproducts" output="false" {

	property name="productTypeID" ormtype="int" fieldtype="id" generator="identity";
	property name="productTypeName" type="string";
	property name="productTypeParam" type="string";
	property name="productTypeClassName" type="string";
	
	property name="Products" type="array" fieldtype="one-to-many" 
		cfc="Product" singularname="Product" 
		fkcolumn="productTypeID";
	
	property name="Prices" type="array" fieldtype="one-to-many" 
		cfc="ProductPrice" singularname="Price"  fkcolumn="productTypeID";
	
	this.constraints = {
		productTypeName = {required=true,size="2..100", fieldvalue = this.getProductTypeName(), 
			validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"},
		productTypeParam = {required=true,size="2..50", fieldvalue = this.getProductTypeParam(), 
			validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"},
		productTypeClassName = {required=true,size="2..100", fieldvalue = this.getProductTypeClassName(), 
			validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"}
	};
}