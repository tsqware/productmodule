component extends="EntityService" {
	public FormConfigService function init(required any fcdao) {
		variables.dao = arguments.fcdao;
		return this;
	
	}
	/* base methods 
		public any function new(){}	
		public any function load(numeric id=0) {}		
		public any function loadByParam(String paramname="none") {}	
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
		
		var newEnt = populate(argumentcollection=arguments);		
		request.valerrors = variables.dao.validate(newEnt);
		
		if (ArrayIsEmpty(request.valerrors)) {			
			var txn = ormGetSession().beginTransaction();
			try {
				if(IsNull(newEnt.getFormConfigID())) save(newEnt);
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
	
	public String function _save(obj) {
		return variables.dao._save(obj);
	}	
	public String function _delete(obj) {
		return variables.dao._delete(obj);
	}	
}