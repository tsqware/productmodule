component persistent="true" table="conf_products_dropinprogramscheduleitems"
{
	property name="scheduleItemID" ormtype="int" fieldtype="id" generator="identity";
	
	/**
	 * @required true
	 * @size 2..100
	 * @fieldvalue this.getScheduleItemName()
	 * @validator plugins.ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars
	 **/
	property name="scheduleItemName" type="string" ;
	
	/**
	 * @required true
	 * @size 2..50
	 * @fieldvalue this.getScheduleItemParam()
	 * @validator plugins.ProductModule.adminconfig.model.ent.ProductValidator.validateForIllegalChars
	 **/
	property name="scheduleItemParam" type="string" ;
	
	/**
	 * @required true
	 * @isvalid date
	 **/
	property name="startTime" type="date" ormtype="timestamp";
	
	/**
     * @required true
	 * @isvalid date  
     **/
	property name="endTime" type="date" ormtype="timestamp";
	
	/**
     * @required true
     * @inList interval,indefinitely
     **/
	property name="repeat" type="string" ;
	
	property name="displayStartDate" type="date" ;
	property name="displayEndDate" type="date" ;
	
	property name="program" fieldtype="many-to-one" cfc="DropInProgram" fkcolumn="productID";
	property name="scheduleDays" fieldtype="collection" type="array" 
		table="conf_products_dropinprogramscheduleitems_days" fkcolumn="scheduleItemID" elementcolumn="dayOfWeekNum" elementtype="string";
		
	
}