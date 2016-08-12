<cfcomponent extends="EntityDAO">
	
	<cffunction name="init" access="public" returntype="ContactFormDAO">
		<cfreturn this />
	</cffunction>
	
	<cfscript>
		
		public any function populate(required obj, rc) {
			obj.setProductName(rc.productName);
			obj.setProductURLParam(rc.productURLParam);
			obj.setProductClassName(rc.productClassName);
			if( StructKeyExists(rc, isSoldOut) ) obj.setIsSoldOut(rc.isSoldOut);
			return obj;
		}
		
		public array function validate(ent) {
			result = [];
			hyrule =  new hyrule.system.core.hyrule();
			result = hyrule.validate(ent);
			arr = [];
			for (i=ArrayLen(result.getErrors()); i>= 1; i--) {
				ArrayAppend(arr, result.getErrors()[i]);
			}	
			return arr;
		}
	
		/**
		**
		** @hint I will save an object
		**
		***/
		public void function save(ent) {
			EntitySave(ent);
		}
		
		public String function _save(obj) {
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
					if (IsNull(obj.getProductID())) {
						EntitySave(populatedObj);
						message = "The new Contact Form '#populatedObj.getProductName()#' is now saved.";
					}
					else {message = "The existing Contact Form '#populatedObj.getProductName()#' is now saved.";}
				}
			}
			catch(any e) {
				txn.rollback();
				
				message = "There was a problem saving the Contact Form.";
				WriteDump(e);
				throw e;
			}
			txn.rollback();
			return message;
			
		}
		
		/* public void saveTransaction > populate, validate, save */
		
		/**
		**
		** @hint I will delete an object
		**
		***/
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
	</cfscript>
</cfcomponent>