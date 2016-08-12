<cfcomponent extends="EntityDAO">
	
	<cffunction name="init" access="public" returntype="EmailNotificationDAO">
		<cfreturn this />
	</cffunction>
	
	<cfscript>
		
		public any function populate(required obj, rc) {
			var ent = obj;
			ent.setEmailSubject(rc.emailSubject);
			if (StructKeyExists(rc, "emailGoesto")) ent.setEmailGoesTo(rc.emailGoesTo);
			if (StructKeyExists(rc, "emailGoesToHidden")) ent.setEmailGoesTo(rc.emailGoesToHidden);			
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
		public void function save(ent) {
			EntitySave(ent);
		}
		
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