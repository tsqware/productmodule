
component extends="EntityService" {
	public any function init(any prdao) 
	{	
		variables.dao = arguments.prdao;
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
	
	public any function loadByParam(String paramname="none") {
		var result = EntityLoad("Product", {productURLParam = arguments.paramname});
		if (IsArray(result) && ArrayLen(result) >= 1)
			result = result[1];
		return result;
	}	
	
	public any function populate(required obj) {
		return variables.dao.populate(obj);
	}
	
	public Array function listInProductType(required String producttype) {
		return variables.dao.listInProductType(producttype);
	}
	
	public void function save(obj, producttype, venuecontacts, formconfig)	{
		variables.dao.save(argumentcollection="#arguments#");
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