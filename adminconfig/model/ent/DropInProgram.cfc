component extends="Product" persistent="true" table="conf_products_dropinprogram" datasource="devcpctproducts" joincolumn="productID"  {	

	property name="scheduleItems" type="array" fieldtype="one-to-many"
		cfc="DropInProgramScheduleItem" singularname="ScheduleItem" fkcolumn="productID";
		
}