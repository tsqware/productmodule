/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {
	
	property FormConfigService;
	property EmailNotificationService;
	property EmailRecipientService;
	property EmailSenderService;
	property RequiredFieldService;
	property PaymentTypeService;
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
		param name ="rc.formName" default = "";
		param name ="rc.formParam" default = "";
		param name ="rc.hasPaymentType" default = true;
		rc.title = "New Form Settings";

		//WriteDump(rc);
		//abort;
			
		if (!StructKeyExists(rc, "prod")) {
			rc.message = "Unable to create Form Settings - not associated with a Product";
		}
		else {
			rc.requiredFields = RequiredFieldService.list();
			rc.paymentTypes = PaymentTypeService.list();
			rc.formAction = {
				action= 'adminconfig:formconfig.doCreate'
			};
			//rc.VenueEmailNotifications = EmailNotificationService.list(filter={emailGoesTo='venue'});
			//rc.CustEmailNotifications = EmailNotificationService.list(filter={emailGoesTo='customer'});

			loadAssociatedProduct(rc,'prod');
			rc.formName = rc.thisProduct.getProductName();
			rc.formParam = rc.thisProduct.getProductURLParam();
			// TODO:::: create function
			if (rc.thisProduct.getProductType().getProductTypeParam() == 'contact-form') {
				rc.hasPaymentType = false;
			}
		}		
	}
	public any function doCreate(required rc) {
		var ent = FormConfigService.new();
		
		removeAssociatedValues(ent);
		populateAssociatedValues(rc,ent);

		FormConfigService.handleInsert(ent, rc);
		
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;
		
		if (rc.messageStatus eq "success") {
			rc.message = "The Form Settings for form #rc.formName# are now saved.";
			var formConfigID = ent.getFormConfigID();
			variables.fw.redirect(action="adminconfig:formconfig.edit", querystring='conf=#formConfigID#', preserve="all");			
		}
		else {
			rc.message = "The Form Settings for form #rc.formName# were not saved.";
			variables.fw.redirect(action="adminconfig:formconfig.create", preserve="all");
		}
		
	}	
	
	public any function edit(required rc) {
		rc.title = "Edit Form Settings";
		param name="rc.hasRequiredField" default="false";
		param name="rc.hasVenueEmailNotification" default="false";
		param name="rc.hasCustEmailNotification" default="false";
		param name="rc.selectedRequiredFields" default=ArrayNew(1);
		param name="rc.hasPaymentType" default="true";
		param name="rc.paymentTypesForForm" default=[];
		if (StructKeyExists(rc, "conf")) {
			rc.thisFormConfig = FormConfigService.load(rc.conf);
			rc.formName = rc.thisFormConfig.getFormName();
			rc.formParam = rc.thisFormConfig.getFormParam();
			rc.requiredFields = RequiredFieldService.list();
			rc.paymentTypes = PaymentTypeService.list();
			rc.VenueEmailNotifications = EmailNotificationService.list(filter={emailGoesTo='venue'});
			rc.CustEmailNotifications = EmailNotificationService.list(filter={emailGoesTo='customer'});

			rc.selectedEmailsToVenue = [];
			rc.selectedEmailsToCustomer = [];

			rc.formAction = {action="adminconfig:formconfig.doEdit"};

			if(rc.thisFormConfig.hasRequiredField()) {
				rc.hasRequiredField = true;
				rc.selectedRequiredFields = rc.thisFormConfig.getRequiredFields();
			}

			if(rc.thisFormConfig.hasPaymentType()) {
				rc.paymentTypesForForm = rc.thisFormConfig.getPaymentTypes();
			}
			//WriteDump(rc.hasRequiredField);
			
			if(rc.thisFormConfig.hasEmailNotification()) {
				for(v in rc.thisFormConfig.getEmailNotifications()) {
					if(v.getEmailGoesTo() == 'venue') {
						rc.hasVenueEmailNotification = true;
						ArrayAppend(rc.selectedEmailsToVenue, v);
					}
					else if(v.getEmailGoesTo() == 'customer') {
						rc.hasCustEmailNotification = true;
						ArrayAppend(rc.selectedEmailsToCustomer, v);
					}
				}
			}
			rc.hasProduct = rc.thisFormConfig.hasProduct();
			//WriteDump(rc.hasProduct); abort;

			// TODO::::  create function with this block
			if (rc.hasProduct) {
				var thisProduct = rc.thisFormConfig.getProduct();
				rc.productName = thisProduct.getProductName();
				rc.productURLParam = thisProduct.getProductURLParam();
				var productType = thisProduct.getProductType();
				rc.productTypeName = productType.getProductTypeName();
				rc.productTypeParam = productType.getProductTypeParam();

				productTypeLink = Replace(rc.productTypeParam, "-", "", "all");
				rc.productEditLink = {
					action='adminconfig:#productTypeLink#.edit', 
					querystring='prod=#rc.productURLParam#'
				};
				rc.formAction.querystring='prod=#rc.productURLParam#';

				// TODO:::: create function
				if (thisProduct.getProductType().getProductTypeParam() == 'contact-form') {
					rc.hasPaymentType = false;
				}
			}


			
			//WriteDump(rc.selectedEmailsToVenue);
			//abort;

		}
		else {
			rc.message = "Form Settings could not be found.";
		}
	}
	public any function doEdit(required rc) {
		if (!StructKeyExists(rc, "conf")) {
			rc.messagestatus = "notfound";
			rc.message = "Form Settings could not be found";
		}
		else {
			var ent = FormConfigService.load(rc.conf);
			removeAssociatedValues(ent);
			populateAssociatedValues(rc,ent);
			//WriteDump(var=ent, abort=true);

			FormConfigService.handleInsert(ent, rc);

			loadVarsForRedirect(rc);
			
			if (rc.messageStatus eq "success") {
				rc.message = "The Form Settings for <b>#rc.formName#</b> was saved.";
				//WriteDump(var=ent, label="ent saved");
				variables.fw.redirect(action="adminconfig:formconfig.edit", querystring="conf=#rc.conf#", preserve="message");
			}
			else {
				rc.message = "The Form Settings were not saved.";
				variables.fw.redirect(action="adminconfig:formconfig.edit", querystring="conf=#rc.conf#", preserve="all");		
			}		
		}
	}
	
	public any function delete(required rc) {
		
	}
	public any function doDelete(required rc) {
		
	}
	
	private function removeAssociatedValues(ent) {
		if (ent.hasRequiredField()) {
			ent.setRequiredFields(JavaCast("null", ""));
		}
		
		if (ent.hasEmailNotification()) {
			ent.setEmailNotifications(JavaCast("null", ""));
		}
		
		if (ent.hasPaymentType()) {
			ent.setPaymentTypes(JavaCast("null", ""));
		}		
	}
	
	private function populateAssociatedValues(rc,ent) {
		var emailNotificationArray = [];			
		if (StructKeyExists(rc, "venueEmailNotificationID")) {
			custEmailNotification = EmailNotificationService.load(rc.venueEmailNotificationID);
				ArrayAppend(emailNotificationArray, custEmailNotification);
		}
		if (StructKeyExists(rc, "custEmailNotificationID")) {
			venueEmailNotification = EmailNotificationService.load(rc.custEmailNotificationID);
			ArrayAppend(emailNotificationArray, venueEmailNotification);
		}		
		ent.setEmailNotifications(emailNotificationArray);
		
		if (StructKeyExists(rc, "fieldID")) {
			var requiredFieldArray = [];
			for (l=1; l<= ListLen(rc.fieldID); l++) {
				requiredField = RequiredFieldService.load(ListGetAt(rc.fieldID, l));
				ArrayAppend(requiredFieldArray, requiredField);
			}
			ent.setRequiredFields(requiredFieldArray);
		}
		if (StructKeyExists(rc, "paymentTypeID")) {
			var paymentTypeArray = [];
			for (l=1; l<= ListLen(rc.paymentTypeID); l++) {
				paymentType = PaymentTypeService.load(ListGetAt(rc.paymentTypeID, l));
				ArrayAppend(paymentTypeArray, paymentType);
			}
			ent.setPaymentTypes(paymentTypeArray);
		}
		
		if (StructKeyExists(rc, "productID")) {
			var product = ProductService.load(rc.productID);
			ent.setProduct(product);
			product.setFormConfig(ent);
		}
	}

}