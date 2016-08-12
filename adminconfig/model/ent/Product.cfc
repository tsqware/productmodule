component persistent="true" table="conf_products" datasource="devcpctproducts" {
	property name="productID" ormtype="int" setter="false" fieldtype="id" generator="identity";
	
	/**
	 * @required true
	 * @unique true
	 * @size 2..100 
	 * @validator ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars
	 **/
	property name="productName" type="String" ;
	
	
	//property name="productParam" type="String" ;
	
	/**
	 * @required true 
	 * @unique true
	 * @size 2..50 
	 * @validator ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars
	 **/
	property name="productURLParam";

	/**
	 * @required true 
	 * @unique true
	 * @size 2..50 
	 * @validator ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars
	 **/
	property name="productClassName";
	
	/**
	 * @boolean true
	 **/
	property name="isSoldOut" type="boolean" default="false" ;
	
	property name="FormConfig" fieldtype="one-to-one" 
		cfc="FormConfig" mappedby="Product";
	
	property name="ProductType" fieldtype="many-to-one" 
		cfc="ProductType" fkcolumn="productTypeID" ;
	
	property name="Prices" type="array" fieldtype="one-to-many"
		cfc="ProductPrice" singularname="Price" 
		fkcolumn="productID";
	
	property name="VenueContacts" type="array" fieldtype="many-to-many" 
		cfc="VenueContact" singularname="VenueContact" 
		linktable="conf_link_products_venuecontacts" 
		fkcolumn="productID" inversejoincolumn="venueContactID" ;
		
	
	
    
    /*
    property name="EmailNotifications" cfc="EmailNotification" type="array" fieldtype="one-to-many" singularname="EmailNotification" fkcolumn="productID" ;
	
	
	property name="PaymentTypes" cfc="PaymentType" singularname="PaymentType" linktable="SP_Products_PaymentTypes" fieldtype="many-to-many" type="array" fkcolumn="productID" inversejoincolumn="paymentTypeID";
	property name="RequiredFields" cfc="RequiredField" singularname="RequiredField" linktable="SP_Products_RequiredFields" fieldtype="many-to-many" type="array" fkcolumn="productID" inversejoincoumn="fieldID";
	*/

	public any function init() {
		return this;
	}
	
	public array function validate(ent=this) {
		result = [];
		hyrule =  new hyrule.system.core.hyrule();
		validation = hyrule.validate(this);
		result = validation.getErrors();
		
		return result;
	}
	
	
}