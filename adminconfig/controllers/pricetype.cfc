/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	
	property PriceTypeService;
	
	// *********************************  PAGES  *******************************************

	public any function default(required rc) {
		// must have rc.prod
		// or display alert
		// show: from recent event date, or all
		// get list of event dates for sidebar nav
		
		
	}
	public any function list(required rc) {
		rc.productTypes = ProductTypeService.list();
	}
	public any function create(required rc) {
		param name = "rc.priceTypeName" default="";
		param name = "rc.priceTypeParam" default="";
		param name = "rc.priceTypeClassName" default="";
		rc.title = "New Price Type";
	}
	public any function doCreate(required rc) {
		var ent = PriceTypeService.new();
		WriteDump(ent);
		PriceTypeService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Price Type <b>#rc.priceTypeName#</b> was saved.";
		}
		else {
			rc.message = "The Price Type was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:pricetype.create", preserve="all");
	}	
	
	public any function edit(required rc) {
		if (StructKeyExists(rc, "prodtype")) {
			rc.thisProductType = ProductTypeService.loadByParam(rc.prodtype);
			rc.productTypeName = rc.thisProductType.getProductTypeName();
			rc.productTypeParam = rc.thisProductType.getProductTypeParam();
			rc.productTypeClassName = rc.thisProductType.getProductTypeClassName();
		}
		else {
			rc.message = "Product Type could not be found.";
		}
	}
	public any function doEdit(required rc) {
		WriteDump(var=rc, abort=false);
		if (StructKeyExists(rc, "prodtype")) {
			var ent = ProductTypeService.loadByParam(rc.prodtype);
		}
		else {
			var ent = ProductTypeService.new();
		}
		WriteDump(ent);
		abort;
		ProductTypeService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Product Type <b>#rc.productTypeName#</b> was saved.";
		}
		else {
			rc.message = "The Product Type was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:producttype.create", preserve="all");
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}

}