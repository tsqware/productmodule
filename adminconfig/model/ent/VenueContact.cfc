component  extends="Contact" persistent="true" table="conf_venuecontacts" joincolumn="venueContactID" datasource="devcpctproducts" 
{
	property name="Products" type="array" fieldtype="many-to-many" 
		cfc="Product" singularname="Product" inverse="true" 
		linktable="conf_link_products_venuecontacts" 
		fkcolumn="venuecontactID" inversejoincolumn="productID";

}