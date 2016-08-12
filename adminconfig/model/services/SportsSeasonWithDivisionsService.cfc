component extends="EntityService" {
	public any function init(any seasonwithdivdao) 
	{	
		variables.dao = arguments.seasonwithdivdao;
		return this;
	
	}
	
	/* base methods 
		public any function new(){}	
		public any function load(numeric id=0) {}		
		
		public any function list() {}		
		public void function save(obj)	{}				
		public void function delete(obj) {}
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
		//WriteDump(var=newEnt, label="newEnt", abort=true);	
		request.valerrors = variables.dao.validate(newEnt);
		//WriteDump(request.valerrors);
		//abort;
		//WriteDump(request);
		
		if(ArrayIsEmpty(request.valerrors)) {
			var txn = ormGetSession().beginTransaction();
			try {
				if(IsNull(newEnt.getSeasonID())) {
					save(newEnt);					
				}
				if(newEnt.hasDivision()) {
					for(dv in newEnt.getDivisions()) {
						//WriteDump(lg);
						dv.setSeason(newEnt);
					}
				}
				
				txn.commit();
				//WriteDump(newEnt);
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
			request.messageStatus = "validationError";
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