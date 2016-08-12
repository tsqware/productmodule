<cfcomponent extends="EntityDAO">
	
	<cffunction name="init" access="public" returntype="FormConfigDAO">
		<cfreturn this />
	</cffunction>
	
	<cfscript>
	
	public any function populate(required obj, rc) {
		var ent = obj;
		
		ent.setFormName(rc.formName);
		ent.setFormParam(rc.formParam);
			
		return ent;
	}
	
	public array function validate(ent) {
		result = [];
		hyrule =  new hyrule.system.core.hyrule();
		//WriteDump(var=hyrule,label="hyrule");
		
		result = hyrule.validate(ent);		
		return result.getErrors();
	}
	
	/**
	**
	** @hint I will save an object
	**
	***/
	public void function save(obj) {
		EntitySave(obj);
	}
	
	public String function _save(obj, productobj) {
		/* populate entity */
		
		//WriteDump(arguments);
		
		var txn = ormGetSession().beginTransaction();
		
		try {
			
			// populate
			populatedObj = populate(obj);
			
			//WriteDump(populatedObj);
			
			// validate
			request.errors = validate(populatedObj);
			//WriteDump(request.errors);
			
			
			
			if (!ArrayIsEmpty(request.errors)) {
				// message - fail
				// show errors
				message = "The form could not be completed - validation errors.";
			}
			else {
				// this program
				//request.programname = populatedObj.getProgram().getProgramName();
				//request.programparam = populatedObj.getProgram().getProgramParam();
				
				// save the entity using the appropriate strategy
				if (IsNull(obj.getFormConfigID())) {
					EntitySave(populatedObj);
					message = "The new Form Config '#populatedObj.getFormName()#' is now saved.";
				}
				else {message = "The existing Form Config '#populatedObj.getFormName()#' is now saved.";}
			}
		}
		catch(any e) {
			txn.rollback();
			
			message = "There was a problem saving the Form Configuration.";
			WriteDump(e);
			throw e;
		}
		txn.rollback();
		return message;
		
	}
	
	/**
	**
	** @hint I will delete an object
	**
	***/
	public void function delete(obj) {
		EntityDelete(arguments.obj);
	}
	
	public String function _delete(obj) {
		var txn = ormGetSession().beginTransaction();
		
		try {
			populatedObj = obj;
			EntityDelete(obj);
			message = "The Form Config '#populatedObj.getFormName()#' is now deleted.";
		}
		catch(any e) {
			txn.rollback();
			
			message = "There was a problem deleting the Form Config.";
			WriteDump(e);
			throw e;
		}
		txn.rollback();
		return message;
	}
	
	public numeric function count() {
		return ArrayLen(EntityLoad(getEntity()));
	}
	
	
	
	private string function getEntity() {
		var meta = getMetadata(this);
		var entity = "";
		
		//WriteDump(meta);
		if (StructKeyExists(meta,"entity")) {
			//get metadata for entity name
			entity = meta.entity;
		}
		else {
			// read the service name and extract the first part as the entity name
			if (StructKeyExists(meta,"fullname")) {
				var service = listLast(meta.fullname,".");
				entity = replaceNoCase(service,"dao","");
			}	
		}
		
		return entity;
	}
	
	/*public any function populate(obj, product, emails, fields, paymenttypes)
	{
		//WriteDump(arguments);
		//var util = new com.Utility().init();
		var fc = form;
		var ent = obj;
		
		ent.setFormName(fc.formName);
		ent.setFormParam(fc.formParam);
		
		if (!IsNull(arguments.product))
			ent.setProduct(product);
			
		if (!IsNull(arguments.emails))
			ent.setEmailNotifications(emails);
		
		if (!IsNull(arguments.fields))
			ent.setRequiredFields(fields);
			
		if (!IsNull(arguments.paymenttypes))
			ent.setPaymentTypes(paymenttypes);
			
		//WriteDump(ent);
		//abort;
	
		return ent;
	}
	
	public array function validate(ent) {
		result = [];
		hyrule =  new hyrule.system.core.hyrule();
		
		result = hyrule.validate(ent);		
		return result.getErrors();
	}*/

		
		
	</cfscript>
	
	
</cfcomponent>