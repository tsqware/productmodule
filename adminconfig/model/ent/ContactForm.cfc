component extends="Product" persistent="true" 
	table="conf_products_contactform" datasource="devcpctproducts" joincolumn="productID"  {
	public any function init() {
		super.init();
		return this;
	}			
}