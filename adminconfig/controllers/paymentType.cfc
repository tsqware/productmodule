/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	
	property PaymentTypeService;
	property FormConfigService;
	property ProductService;
	
	// *********************************  PAGES  *******************************************

	public any function default(required rc) {
		// must have rc.prod
		// or display alert
		// show: from recent event date, or all
		// get list of event dates for sidebar nav
		
		
	}
	public any function list(required rc) {
		rc.title = "Payment Types";
		rc.paymentTypes = PaymentTypeService.list();
	}
	public any function create(required rc) {
		param name = "rc.paymentTypeName" default="";
		param name = "rc.paymentTypeParam" default="";
		param name = "rc.messagestatus" default="";
		param name = "rc.valerrors" default=[];
		rc.title = "New Payment Type";

		if (!StructKeyExists(rc, "conf")) {
			rc.hasConf = false;
			rc.messagestatus = "notfound";
			rc.message = "Payment Type must be associated with a form.";
			return;
		}
		else {
			rc.formConfigID = rc.conf;
			confObj = FormConfigService.load(rc.conf);
			if (!IsBoolean(confObj)) {
				rc.formName = confObj.getFormName();
				rc.formParam = confObj.getFormParam();

				rc.formConfigLink = Replace(rc.formParam, "-", "", "all");
				rc.formAction = {
					action='adminconfig:emailnotification.doCreate',
					querystring='conf=#rc.conf#'
				};
				rc.formEditLink = {
					action='adminconfig:formconfig.edit', 
					querystring='conf=#rc.conf#'
				};
				rc.formAction.querystring='conf=#rc.conf#';

				if(confObj.hasProduct()) {
					rc.prod = confObj.getProduct().getProductURLParam();
					loadAssociatedProduct(rc,"prod");
				}
			}
			else {
				rc.hasConf = false;
				rc.message = "Payment Type must be associated with a form.";
			}
		}

	}
	public any function doCreate(required rc) {
		var ent = PaymentTypeService.new();
		PaymentTypeService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Payment Type <b>#rc.paymentTypeName#</b> was saved.";
		}
		else {
			rc.message = "The Payment Type was not saved.";			
		}
		variables.fw.redirect(action="adminconfig:paymenttype.create", preserve="all");
	}	
	
	public any function edit(required rc) {
		param name="rc.messagestatus" default="";
		param name="rc.message" default="";
		param name="rc.valerrors" default=[];
		rc.title = "Edit Payment Type";

		if (StructKeyExists(rc, "paytype")) {
			rc.paymentType = PaymentTypeService.load(paytype);

			WriteDump(rc.paymentType); abort;

			if (rc.messagestatus neq "notfound") {
				rc.paymentTypeName = rc.paymentType.getPaymentTypeName();
				rc.paymentTypeParam = rc.paymentType.getPaymentTypeParam();

				var hasConf = rc.paymentType.hasFormConfig();
				WriteDump(hasConf); abort;

				if (!StructKeyExists(rc, "conf")) {
					rc.hasConf = false;
					rc.messagestatus = "notfound";
					rc.message = "Payment Type must be associated with a form.";
					return;
				}
				else {
					rc.formConfigID = rc.conf;
					confObj = FormConfigService.load(rc.conf);
					if (!IsBoolean(confObj)) {
						rc.formName = confObj.getFormName();
						rc.formParam = confObj.getFormParam();

						rc.formConfigLink = Replace(rc.formParam, "-", "", "all");
						rc.formAction = {
							action='adminconfig:emailnotification.doCreate',
							querystring='conf=#rc.conf#'
						};
						rc.formEditLink = {
							action='adminconfig:formconfig.edit', 
							querystring='conf=#rc.conf#'
						};
						rc.formAction.querystring='conf=#rc.conf#';

						if(confObj.hasProduct()) {
							rc.prod = confObj.getProduct().getProductURLParam();
							loadAssociatedProduct(rc,"prod");
						}
					}
					else {
						rc.hasConf = false;
						rc.message = "Payment Type must be associated with a form.";
					}
				}
			}
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