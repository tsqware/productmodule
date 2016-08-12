component persistent="true" table="conf_prices" {
	property name="priceID" ormtype="int" fieldtype="id" generator="identity";
	property name="priceName";
	property name="priceParam";
	property name="priceAmount";
	
	property name="PriceType" fieldtype="many-to-one" cfc="PriceType" fkcolumn="priceTypeID";
	
	
	
	this.constraints = {
		priceName = {required=true,size="2..100",validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"},
		priceParam = {required=true,size="2..50",validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"},
		priceAmount = {required=true,numeric=true,validator="ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars"}
	};
	
}