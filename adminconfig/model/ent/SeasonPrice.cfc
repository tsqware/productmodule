component extends="Price" persistent="true" table="conf_prices_season" 
	datasource="devcpctproducts" joincolumn="seasonPriceID"
	hint="Prices that are directly linked to a Season."
{
	property name="season" fieldtype="many-to-one" 
		cfc="SportsSeason" singularname="season"
		fkcolumn="seasonID";
}