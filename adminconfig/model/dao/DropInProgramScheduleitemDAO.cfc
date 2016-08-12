<cfcomponent extends="EntityDAO">
	
	<cffunction name="init" access="public" returntype="DropInProgramScheduleItemDAO">
		<cfreturn this />
	</cffunction>
	
	<cfscript>
		
		public any function populate(required obj, rc) {
			obj.setScheduleItemName(rc.scheduleItemName);			
			obj.setScheduleItemParam(rc.ScheduleItemParam);
			if(Len(rc.startTime)) obj.setStartTime(rc.startTime);
			if(Len(rc.endTime)) obj.setEndTime(rc.endTime);
			
			// if a repeat value is checked
			if(IsDefined("rc.repeat")) {
				// if indefinitely, clear values for displayStartDate and displayEndDate
				if(rc.repeat == "indefinitely") {
					rc.displayStartDate = "";
					rc.displayEndDate = "";
				}
				
				obj.setRepeat(rc.repeat);
				
				// if displayStartDate is entered
				if(Len(rc.displayStartDate)){
					obj.setDisplayStartDate(
						CreateDate(
							Year(rc.displayStartDate),
							Month(rc.displayStartDate),
							Day(rc.displayStartDate)
						)
					);
				}
				// if not, make it null
				else {
					obj.setDisplayStartDate(JavaCast("null",""));
				}
				
				// same with displayEndDate
				if(Len(rc.displayEndDate)) {
					obj.setDisplayEndDate(
						CreateDate(
							Year(rc.displayEndDate),
							Month(rc.displayEndDate),
							Day(rc.displayEndDate)
						)
					);
				}
				else {
					obj.setDisplayEndDate(JavaCast("null",""));
				}
			}			
			
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
			if( IsNull(ent.getScheduleDays()) || ArrayIsEmpty(ent.getScheduleDays())) {
				result.addError(
					"plugins.ProductModule.adminconfig.model.ent.DropInProgramScheduleItem",
					"property", 
					{name="ScheduleDays"},
					"NotEmpty",
					"Please select at least one day."
				);
				ArrayAppend(
					arr, 
					result.getErrors()[ ArrayLen( result.getErrors() )]
				);
			}
			
			if( 
				ent.getRepeat() == "interval" && 
				(
					IsNull(ent.getDisplayStartDate()) 
					|| Len(ent.getDisplayStartDate()) eq 0 
				)
			) {
				result.addError(
					"plugins.ProductModule.adminconfig.model.ent.DropInProgramScheduleItem",
					"property", 
					{name="DisplayStartDate"},
					"NotEmpty",
					"Display Start Date is required."
				);
				ArrayAppend(
					arr, 
					result.getErrors()[ ArrayLen( result.getErrors() )]
				);
			}
			if( 
				ent.getRepeat() == "interval" && 
				(
					IsNull(ent.getDisplayEndDate()) 
					|| Len(ent.getDisplayEndDate()) eq 0 
				)
			) {
				result.addError(
					"plugins.ProductModule.adminconfig.model.ent.DropInProgramScheduleItem",
					"property", 
					{name="DisplayEndDate"},
					"NotEmpty",
					"Display End Date is required."
				);
				ArrayAppend(
					arr, 
					result.getErrors()[ ArrayLen( result.getErrors() )]
				);
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