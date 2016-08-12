<cfcomponent extends="EntityDAO">
	
	<cffunction name="init" access="public" returntype="ProductTransactionDAO">
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
		
		public any function populate(tr) {
			tr.setTransactionDate(CreateODBCDateTime(now()));
			tr.setTransactionStatus('pending');				
			return tr;
		}
		
		public array function validate(ent) {
			result = [];
			hyrule =  new hyrule.system.core.hyrule();
			result = hyrule.validate(ent);		
			return result.getErrorMessages();
		}
		
		/**
		**
		** @hint I will save an object
		**
		***/
		public void function save(tr) {
			EntitySave(tr);
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
		**
		** @hint I will show the record count of an entity
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