/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	
	property ProductPriceService;
	property PriceTypeService;
	property ProductService;
	property ProductTypeService;
	
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
		rc.title="New Product Price";
		param name = "rc.priceName" default="";
		param name = "rc.priceParam" default="";
		param name = "rc.priceAmount" default="";
		param name = "rc.messagestatus" default="";
		
		rc.pricetype = "product";
		rc.Products = ProductService.list();
		rc.ProductTypes = ProductTypeService.list();

		if (StructKeyExists(rc, "pricetype")) {
			// get the price type name associated with the pricetype param
			var thisPriceType = PriceTypeService.loadByParam(rc.pricetype);
			if (IsBoolean(thisPriceType) && !thisPriceType) {
				rc.messagestatus = "notfound";
				rc.message = "The page could not be found 1.";
			}
			else {
				rc.priceTypeID = thisPriceType.getPriceTypeID();
				rc.priceTypeName = thisPriceType.getPriceTypeName();
			}

			loadAssociatedProduct(rc, "prod");

			if (!StructKeyExists(rc, "prod")) {
				rc.messagestatus = "notfound";
				rc.message = "The price is not associated with a product.";
			}
		}
		else {
			// alert that the page cannot be found
			rc.messagestatus = "notfound";
			rc.message = "The page could not be found 2.";
		}
	}
	public any function doCreate(required rc) {
		var ent = ProductPriceService.new();
		var selectedProducts = []; 
		
		if (StructKeyExists(rc, "priceTypeID")) {				
			var ptEnt = PriceTypeService.load(rc.priceTypeID);
			ent.setPriceType(ptEnt);
		}
		if (StructKeyExists(rc, "productID")) {
			var product = ProductService.load(rc.productID);
			if (product.hasProductType()) {
				var productType = product.getProductType();
				ent.setProductType(productType);
			}
			ent.setProduct(product);
		}

		ProductPriceService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Product Price <b>#rc.priceName#</b> is now saved.";
			var priceID = ent.getPriceID();
			variables.fw.redirect(action="adminconfig:productprice.edit", querystring="prodprice=#priceID#", preserve="message");
		}
		else {
			rc.message = "The Product Price was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:productprice.create", preserve="all");
	}	
	
	public any function edit(required rc) {
		rc.title = "Edit Product Price";
		param name = "rc.priceName" default="";
		param name = "rc.priceParam" default="";
		param name = "rc.priceAmount" default="";
		param name = "rc.messagestatus" default="";
		
		if (StructKeyExists(rc, "prodprice")) {
			rc.thisProductPrice = ProductPriceService.load(rc.prodprice); // id not param
			rc.priceName = rc.thisProductPrice.getPriceName();
			rc.priceParam = rc.thisProductPrice.getPriceParam();
			rc.priceAmount = rc.thisProductPrice.getPriceAmount();
			rc.priceType = rc.thisProductPrice.getPriceType();
			rc.priceTypeID = rc.priceType.getPriceTypeID();
			rc.priceTypeName = rc.priceType.getPriceTypeName();


			
			rc.ProductTypes = ProductTypeService.list();
			//WriteDump(rc.thisProductPrice);
			//abort;
			rc.productTypeForPrice = rc.thisProductPrice.getProductType();
						
			rc.products = ProductService.list();
			rc.productForPrice = rc.thisProductPrice.getProduct();
			rc.prod = rc.productForPrice.getProductURLParam();

			loadAssociatedProduct(rc, "prod");
			
		}
		else {
			rc.messagestatus = "notfound";
			rc.message = "Product Price could not be found.";
		}
	}
	public any function doEdit(required rc) {
		//WriteDump(var=rc, abort=false);
		if (StructKeyExists(rc, "prodprice")) {
			var ent = ProductPriceService.load(rc.prodprice);
		}
		else {
			var ent = ProductPriceService.new();
		}
		var selectedProductTypes = []; 
		if (StructKeyExists(rc, "priceTypeID")) {				
			var ptEnt = PriceTypeService.load(rc.priceTypeID);
			ent.setPriceType(ptEnt);
		}
		if (StructKeyExists(rc, "productID")) {
			var product = ProductService.load(rc.productID);
			if (product.hasProductType()) {
				var productType = product.getProductType();
				ent.setProductType(productType);
			}					
			ent.setProduct(product);
		}
		// WriteDump(ent);
		// abort;
		ProductPriceService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Product Price <b>#rc.priceName#</b> is now saved.";
		}
		else {
			rc.message = "The Product Price was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:productprice.edit", preserve="all");
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}

}