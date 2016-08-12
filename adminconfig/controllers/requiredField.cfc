/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	
	property RequiredFieldService;
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
		rc.productTypes = ProductTypeService.list();
	}
	public any function create(required rc) {
		param name = "rc.fieldName" default="";
		param name = "rc.fieldParam" default="";
		param name = "rc.hasConf" default=false;
		rc.title = "New Required Field";

		rc.formAction = {
			action= "adminconfig:requiredfield.doCreate"
		};

		if (StructKeyExists(rc, 'conf')) {
			confObj = FormConfigService.load(rc.conf);
			if (!IsBoolean(confObj)) {
				rc.hasConf = true;
				rc.formName = confObj.getFormName();

				rc.formParam = confObj.getFormParam();

				rc.formConfigLink = Replace(rc.formParam, "-", "", "all");
				rc.formEditLink = {
					action='adminconfig:formconfig.edit', 
					querystring='conf=#confObj.getFormConfigID()#'
				};
				rc.formAction.querystring = "conf=#rc.conf#";
				if(confObj.hasProduct()) {
					rc.prod = confObj.getProduct().getProductURLParam();
					loadAssociatedProduct(rc,"prod");
				}
			}
		}
	}
	public any function doCreate(required rc) {
		var ent = RequiredFieldService.new();
		RequiredFieldService.handleInsert(ent, rc);
		
		loadVarsForRedirect(rc);

		rc.editAction = {
			action = "adminconfig:requiredfield.edit",
			preserve = "messagestatus,message,valerrors"
		};
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Required Field <b>#rc.fieldName#</b> was saved.";
			fieldID = ent.getFieldID();
			rc.editAction.querystring = "rf=#fieldID#";
			if(StructKeyExists(rc, 'conf')) {
				rc.editAction.querystring &= "&conf=#rc.conf#";
			}
			variables.fw.redirect(argumentcollection=#rc.editAction#);
		}
		else {
			rc.message = "The Required Field was not saved.";
			variables.fw.redirect(action="adminconfig:requiredfield.create", preserve="all");	
		}
		
	}	
	
	public any function edit(required rc) {
		rc.title = "Edit Required Field";
		rc.valerrors = [];
		param name = "rc.fieldName" default="";
		param name = "rc.fieldParam" default="";
		param name = "rc.hasConf" default=false;

		if (StructKeyExists(rc, "rf")) {
			rc.thisRequiredField = RequiredFieldService.load(rc.rf);
			rc.fieldName = rc.thisRequiredField.getFieldName();
			rc.fieldParam = rc.thisRequiredField.getFieldParam();

			if (StructKeyExists(rc, 'conf')) {
				confObj = FormConfigService.load(rc.conf);
				if (!IsBoolean(confObj)) {
					rc.hasConf = true;
					rc.formName = confObj.getFormName();

					rc.formParam = confObj.getFormParam();

					rc.formConfigLink = Replace(rc.formParam, "-", "", "all");
					rc.formEditLink = {
						action='adminconfig:formconfig.edit', 
						querystring='conf=#confObj.getFormConfigID()#'
					};
					if(confObj.hasProduct()) {
						rc.prod = confObj.getProduct().getProductURLParam();
						loadAssociatedProduct(rc,"prod");
					}
				}				
			}
		}
		else {
			rc.messagestatus = "notfound";
			rc.message = "Required Field could not be found.";
		}
	}
	public any function doEdit(required rc) {
		WriteDump(var=rc, abort=false);
		/*if (StructKeyExists(rc, "rf")) {
			var ent = ProductTypeService.loadByParam(rc.prodtype);
		}
		else {
			var ent = ProductTypeService.new();
		}*/
		if(!StructKeyExists(rc, "rf")) {
			rc.messagestatus = "notfound";
			rc.message = "Required Field could not be found";
		}
		else {
			var ent = RequiredFieldService.load(rc.rf);
			RequiredFieldService.handleInsert(ent, rc);

			loadVarsForRedirect(rc);
			
			if (rc.messageStatus eq "success") {
				rc.message = "The Required Field <b>#rc.fieldName#</b> was saved.";				
				variables.fw.redirect(action="adminconfig:requiredfield.edit", querystring="rf=#rc.rf#&conf=#rc.conf#", preserve="all");
			}
			else {
				rc.message = "The Required Field was not saved.";				
				variables.fw.redirect(action="adminconfig:requiredfield.edit", preserve="all");	
			}
		}
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}

}