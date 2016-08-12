component accessors="true" {
	
	function init(required any dao) {
		variables.dao = dao;
		return this;
	}
	
	public any function new() {
		return variables.dao.new();
	}

	public any function load(numeric id=0) {
		return variables.dao.load(id);
	}
	
	public any function list(
		Struct filter=StructNew(),
		String sortorder="",
		String unique="false",
		Struct options=StructNew()
	)
	{
			
		if ( arguments.unique == "true" ) {
			return variables.dao.list(filter=filter,unique=unique);
		}
		else {
			return variables.dao.list(filter=filter,sortorder=sortorder,options=options);
		}
	}
	
	public void function save(obj)	{
		variables.dao.save(obj);
	}
			
	public void function delete(obj) {
		variables.dao.delete(obj);
	}
	
	public boolean function isFieldRequired(required array ent, required String f) {
		WriteDump(ent);
		result = false;
		doesEntityArrayExist = !IsNull(ent) && IsArray(ent);
		if (doesEntityArrayExist) {
			for (entItem in ent) {
				if (entItem.getFieldName() == f) {
					result = true;
					break;
				}
			}
		}
		return result;
	}
	
		
	
}