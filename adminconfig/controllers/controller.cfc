component {
	public function init(fw) {
		variables.fw = fw;
		return this;
	}

	public function loadAssociatedProduct(rc,prod) {
		if (StructKeyExists(rc, prod)) {
			param name="rc.formAction.querystring" default="";
			//writeDump(rc.formAction);
			//abort;
			rc.thisProduct = ProductService.loadByParam(rc.prod);
			if (IsInstanceOf(rc.thisProduct, "productmodule.adminconfig.model.ent.Product")) {
				productType = rc.thisProduct.getProductType();
				// rc keys needed for display
				rc.productID = rc.thisProduct.getProductID();
				rc.productName = rc.thisProduct.getProductName();
				rc.productURLParam = rc.thisProduct.getProductURLParam();	
				rc.productTypeID = productType.getProductTypeID();			
				rc.productTypeName = productType.getProductTypeName();
				rc.productTypeParam = productType.getProductTypeParam();
				
				productTypeLink = Replace(rc.productTypeParam, "-", "", "all");
				rc.productEditLink = {
					action='adminconfig:#productTypeLink#.edit', 
					querystring='prod=#rc.productURLParam#'
				};
				if (Len(rc.formAction.querystring) > 0) {
					rc.formAction.querystring&='&prod=#rc.productURLParam#';
				}
				else {
					rc.formAction.querystring&='prod=#rc.productURLParam#';
				}
				
			}
		}
	}

	private function loadVarsForRedirect(rc) {
		if (StructKeyExists(request, "messageStatus")) rc.messageStatus = request.messageStatus;
		if (StructKeyExists(request, "message")) rc.message = request.message;
		if (StructKeyExists(request, "valerrors")) rc.valerrors = request.valerrors;		
	}
}