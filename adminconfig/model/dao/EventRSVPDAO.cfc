<cfcomponent extends="EntityDAO">
	
	<cffunction name="init" access="public" returntype="EventRSVPDAO">
		<cfreturn this />
	</cffunction>
	
	<cfscript>
		
		public any function populate(required obj, rc) {
			obj.setProductName(HTMLEditFormat(rc.productName));
			obj.setProductURLParam(rc.productURLParam);
			obj.setProductClassName(rc.productClassName);
			if( StructKeyExists(rc, isSoldOut) ) obj.setIsSoldOut(rc.isSoldOut);

			WriteOutput("
				eventStart: #rc.eventStartDate# #rc.eventStartTime#<br>
				eventEnd: #rc.eventEndDate# #rc.eventEndTime#<br>
				regEnd: #rc.registrationEndDate# #rc.registrationEndTime#<br>
			");
			if(Len(rc.eventStartDate) && Len(rc.eventStartTime)) {
				request.EventStartDateTime = CreateDateTime(
						Year(rc.eventStartDate),
						Month(rc.eventStartDate),
						Day(rc.eventStartDate),
						Hour(rc.eventStartTime),
						Minute(rc.eventStartTime),
						0
					);
				obj.setEventStartDateTime(request.EventStartDateTime);
				
			} 
			if(Len(rc.eventEndDate) && Len(rc.eventEndTime)) {
				request.EventEndDateTime = CreateDateTime(
						Year(rc.eventEndDate),
						Month(rc.eventEndDate),
						Day(rc.eventEndDate),
						Hour(rc.eventEndTime),
						Minute(rc.eventEndTime),
						0
					);
				obj.setEventEndDateTime(request.EventEndDateTime);
			} 
			if(Len(rc.registrationEndDate) && Len(rc.registrationEndTime)) {
				request.RegistrationEndDateTime = CreateDateTime(
						Year(rc.registrationEndDate),
						Month(rc.registrationEndDate),
						Day(rc.registrationEndDate),
						Hour(rc.registrationEndTime),
						Minute(rc.registrationEndTime),
						0
					);
				obj.setRegistrationEndDateTime(request.RegistrationEndDateTime);
			}

			/*WriteOutput("
				eventStart: #request.EventStartDateTime#<br>
				eventEnd: #request.EventEndDateTime#<br>
				regEnd: #request.RegistrationEndDateTime#<br>
			");

			WriteDump(request);
			abort;*/

			//WriteDump(obj);
			//abort;	
			return obj;
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