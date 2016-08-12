component extends="EntityService" {
	public EmailRecipientService function init(required any emrecdao) 
	{
		variables.dao = arguments.emrecdao;
		return this;
	} 
		
	/*
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
		Struct options=StructNew()) {
			
			if ( arguments.unique == "true" ) {
				return variables.dao.list(filter=filter,unique=unique);
			}
			else {
				return variables.dao.list(filter=filter,sortorder=sortorder,options=options);
			}
	}
		
	public void function delete(obj) {
		variables.dao.delete(obj);
	}
	*/
	
	public any function populate(required obj, rc) {
		return variables.dao.populate(argumentcollection=arguments);
	}
	
	public void function save(obj)	{
		variables.dao.save(obj);
	}
	
	public void function handleInsert(obj, rc) {
		request.wasSaved = false;
		var newEnt = populate(obj, rc);
		request.valerrors = variables.dao.validate(newEnt);
		
		if (ArrayIsEmpty(request.valerrors)) {			
			var txn = ormGetSession().beginTransaction();
			try {
				if(IsNull(newEnt.getContactID())) save(newEnt);
				txn.commit();
			}
			catch(any e) {
				txn.rollback();
				request.messageStatus = "error";
				throw e;
			}
			if (txn.wasCommitted()) {
				request.messageStatus = "success";
			}			
		}
		else {
			request.messageStatus = "valiationError";
		}
	}
	
	public boolean function isFieldRequired(required array ent, required String f) {
		WriteDump(ent);
		result = false;
		if (!IsNull(ent) && IsArray(ent)) {
			for (i=1; i<=ArrayLen(ent); i++) {
				if (ent[i].getFieldName() == f) {
					result = true;
					break;
				}
			}
		}
		return result;
	}
	
	public boolean function hasNoIllegalChars(string f) {
		var result = true;
		var pattern = "[\@\(\)\<\>\;\:\\\[\]\~\!\$\%\^\&\*\+\=\{\}\|]";
		var x = ReFind(pattern, arguments.f);
		//WriteDump(x);
		if (x > 0) {result = false;}
		return result;
	}
	
	public String function _save(obj) {
		return variables.dao._save(obj);
	}
	
	public String function _delete(obj) {
		return variables.dao._delete(obj);
	}
			
	
}