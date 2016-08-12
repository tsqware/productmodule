<cfcomponent extends="EntityDAO">
	
	<cffunction name="init" access="public" returntype="DateNightRSVPSelectedDAO">
		<cfreturn this />
	</cffunction>
	
	<cfscript>
		public any function listInProductType(required String producttype) {
			var rows = ORMExecuteQuery("
				SELECT p 
				FROM Product p join p.ProductType pt where pt.prodtypeParam = '#producttype#'
			");
			return rows;
		}
		
		public any function populate(required dnRSVP) {
			dnRSVP.setProductName(form.productName);
			dnRSVP.setProductClassParam(form.productClassParam);
			dnRSVP.setProductURLParam(form.productURLParam);
			dnRSVP.setProductTypeName(form.productType);
			dnRSVP.setEventStart(form.eventStartDate);
			dnRSVP.setEventEnd(form.eventEndDate);
			if (Len(Trim(form.numberOfChildrenOver5)) > 0) dnRSVP.setNumberOfChildrenOver5(form.numberOfChildrenOver5);
			if (Len(Trim(form.numberOfChildrenUnder5)) > 0) dnRSVP.setNumberOfChildrenUnder5(form.numberOfChildrenUnder5);
			if (StructKeyExists(form, "comments")) dnRSVP.setComments(form.comments);
					
			return dnRSVP;
		}
		
		public array function validate(ent) {
			result = [];
			hyrule =  new hyrule.system.core.hyrule();
			result = hyrule.validate(ent);		
			return result.getErrors();
		}	
		
		/**
		 * @hint I will save an object		 *
		 */
		public void function save(dnRSVP) {
			EntitySave(dnRSVP);
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
						message = "The new Product '#populatedObj.getProductName()#' is now saved.";
					}
					else {message = "The existing Product '#populatedObj.getProductName()#' is now saved.";}
				}
			}
			catch(any e) {
				txn.rollback();
				
				message = "There was a problem saving the Product Group.";
				WriteDump(e);
				throw e;
			}
			txn.rollback();
			return message;
			
		}
		
		/**
		 * @hint I will delete an object
		 */	
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