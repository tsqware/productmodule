component extends="Price" persistent="true" table="conf_prices_product" datasource="devcpctproducts" joincolumn="productPriceID"
				hint="Prices that are directly linked to a Product and a Product Type. If a Product is not created it cannot have a Price associated with it. But all products are of a Product Type."
{
	property name="ProductType" cfc="ProductType"
		fieldtype="many-to-one" fkcolumn="productTypeID"; // delete conf_producttypes_prices
	property name="Product" cfc="Product"
		fieldtype="many-to-one"
		fkcolumn="productID"; // delete conf_link_products_prices
}