/**
**
** @displayname AbstractService
** @hint I provide common persistence functionality
**
***/

component {
	public void function init() {
		throw(
			type="AbstractDAO",
			message="AbstractDAO is meant to be extended not instantiated"
		);
	}
	
	/**
	**
	** @hint I will return a new instance of the entity we are working with
	**
	***/
	public any function new() {
		return entityNew(getEntity());
	}
	
	/**
	**
	** @hint I will load an object based on an id. If you pass nothing I will return a new object. If the object doesn't exist I return false.'
	**
	***/
	public any function load(numeric id=0) {
		if (arguments.id ==0) {
			return new();
		}
		else {
			var obj = EntityLoadByPK(getEntity(), arguments.id);
			if (!IsNull(obj)) return obj;
			else return false;
		}
	}
	
	/**
	**
	** @hint I am a generic list function. I have the same arguments as EntityLoad().
	**
	***/
	public any function list(
		Struct filter=StructNew(),
		String sortorder="",
		String unique="false",
		Struct options=StructNew()) {

		if (arguments.unique == "true") {
			var rows = EntityLoad(getEntity(), arguments.filter, arguments.unique);
		}
		else {
			var rows = EntityLoad(getEntity(), arguments.filter, arguments.sortorder, arguments.options);
		}
		
		
		//if (arguments.asquery) {
		//	return EntityToQuery(rows);
		//}
		
		return rows;
	}
	
	/**
	**
	** @hint I will save an object 
	** OVERRIDE this functionality	
	**
	***/
	public void function save(obj) {
		EntitySave(arguments.obj);
	}
	
	/**
	**
	** @hint I will delete an object
	**
	***/
	public void function delete(obj) {
		EntityDelete(arguments.obj);
	}
	
	public numeric function count() {
		return ArrayLen(EntityLoad(getEntity()));
	}
	
	
	
	private string function getEntity() {
		var meta = getMetadata(this);
		var entity = "";
		
		//WriteDump(var=meta, label="test meta");
		//abort;
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
}